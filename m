Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZCWVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZCWVYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZCWVYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:24:45 -0400
Received: from smtp2.ono.com ([62.42.230.20]:14041 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751674AbZCWVYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:24:44 -0400
Date: Mon, 23 Mar 2009 22:24:27 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Problems with default ACLs over NFS
Message-ID: <20090323222427.00bb24e7@werewolf.home>
X-Mailer: Claws Mail 3.7.1cvs22 (GTK+ 2.16.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a strange problem with 2.6.29-rc8-git3.
It looks like a kernel bug... ?

I have a box with NFS autofs-mounted home directories. Server is a
Solaris 10 system. This worked in previous kernel versions, so I
don't blame Solaris, at this moment.

With this acls set in my home:


prometeo:~> getfacl .  

# file: .
# owner: magallon
# group: giga
user::rwx
user:webservd:r-x       #effective:r-x
group::--x      #effective:--x
mask:r-x
other:--x
default:user::rwx
default:group::--x
default:other:--x

I get this strange message in the linux client:

cicely:~> mkdir kk  
mkdir: cannot create directory `kk': Invalid argument

But the directory is created, and its ACLs are correct:

prometeo:~> getfacl kk  

# file: kk
# owner: magallon
# group: giga
user::rwx
group::--x      #effective:--x
other:--x
default:user::rwx
default:group::--x
default:other:--x

If I remove the 'default' entries, the error message goes away.

With strace, I get this:

mkdir("kk", 0777)                       = -1 EINVAL (Invalid argument)

Mount info from /proc/mounts:

ldap:danae-nfs:automountMapName=auto_home,o=diis /home autofs rw,fd=7,pgrp=3165,timeout=600,minproto=5,maxproto=5,indirect 0 0

danae-nfs:/export/home/usuarios/giga/magallon /home/magallon nfs rw,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nointr,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=155.210.152.202,mountvers=3,mountproto=tcp,addr=155.210.152.202 0 0

It happens the same If I try to create a file with "> kk", or try to cp -r one
other dir, but "touch kk" works.

Any idea ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
