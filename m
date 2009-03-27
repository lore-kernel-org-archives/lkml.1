Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZC0AHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZC0AHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbZC0AHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:07:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932697AbZC0AHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:07:04 -0400
Date: Thu, 26 Mar 2009 17:05:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q? "J.A._Magall=F3n" ?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: Problems with default ACLs over NFS
Message-Id: <20090326170513.4e7d377a.akpm@linux-foundation.org>
In-Reply-To: <20090323222427.00bb24e7@werewolf.home>
References: <20090323222427.00bb24e7@werewolf.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-nfs)

On Mon, 23 Mar 2009 22:24:27 +0100 "J.A. Magall__n" <jamagallon@ono.com> wrote:

> Hi all...
> 
> I have a strange problem with 2.6.29-rc8-git3.
> It looks like a kernel bug... ?
> 
> I have a box with NFS autofs-mounted home directories. Server is a
> Solaris 10 system. This worked in previous kernel versions, so I
> don't blame Solaris, at this moment.
> 
> With this acls set in my home:
> 
> 
> prometeo:~> getfacl .  
> 
> # file: .
> # owner: magallon
> # group: giga
> user::rwx
> user:webservd:r-x       #effective:r-x
> group::--x      #effective:--x
> mask:r-x
> other:--x
> default:user::rwx
> default:group::--x
> default:other:--x
> 
> I get this strange message in the linux client:
> 
> cicely:~> mkdir kk  
> mkdir: cannot create directory `kk': Invalid argument
> 
> But the directory is created, and its ACLs are correct:
> 
> prometeo:~> getfacl kk  
> 
> # file: kk
> # owner: magallon
> # group: giga
> user::rwx
> group::--x      #effective:--x
> other:--x
> default:user::rwx
> default:group::--x
> default:other:--x
> 
> If I remove the 'default' entries, the error message goes away.
> 
> With strace, I get this:
> 
> mkdir("kk", 0777)                       = -1 EINVAL (Invalid argument)
> 
> Mount info from /proc/mounts:
> 
> ldap:danae-nfs:automountMapName=auto_home,o=diis /home autofs rw,fd=7,pgrp=3165,timeout=600,minproto=5,maxproto=5,indirect 0 0
> 
> danae-nfs:/export/home/usuarios/giga/magallon /home/magallon nfs rw,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nointr,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=155.210.152.202,mountvers=3,mountproto=tcp,addr=155.210.152.202 0 0
> 
> It happens the same If I try to create a file with "> kk", or try to cp -r one
> other dir, but "touch kk" works.
> 
> Any idea ?
> 

