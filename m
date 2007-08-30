Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbXH3Omo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbXH3Omo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXH3Omf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:42:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45269 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXH3Ome (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:42:34 -0400
Date: Thu, 30 Aug 2007 16:42:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <1188484337.6755.41.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> 
 <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 30 2007 10:29, Trond Myklebust wrote:
>On Thu, 2007-08-30 at 16:12 +0200, Jan Engelhardt wrote:
>> 
>> with NFS3, there is this 'root hole', i.e. any person who has a root 
>> account (perhaps by use of a laptop) can mount an export (let's say this 
>> export had the "root_squash" option), and still have a look at the user 
>> files, because he can locally setuid() into another user.
>> 
>> So I was looking for alternatives. CIFS is my favorite candidate, but it 
>> has a few issues right now. So does sshfs and about everything I have 
>> come across. Since I remember NFS4 can use KRB5 authentification, my 
>> question is, will the NFS(4) server process run with an fsuid equal to 
>> the user that authenticated?
>
>NFSv3 should work fine with krb5 too, but that won't solve your problem
>with setuid: kerberos saves the TGT in a file on /tmp, so root can still
>suid and grab your cred (and the same goes for CIFS).

Hm? I do not see this problem with CIFS. The user may have local
root, but on the server, he only has his non-root account on the
server, and as such, can only operate on the server using this
non-root fsuid. Did I miss something? (Especially the /dev/mem thing
is not quite clear to me.)

>BTW: even when this task is done, a creative root can still find ways to
>subvert the security (he can read /dev/mem, replace the kernel with a
>compromised one, ....). The bottom line is that if you can't trust root,
>don't even log in.


	Jan
-- 
