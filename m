Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYEKRgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYEKRgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYEKRgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:36:09 -0400
Received: from quechua.inka.de ([193.197.184.2]:37996 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYEKRgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:36:08 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: How to change the FSINFO for nfsd?
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <4827227D.6040903@singnet.com.sg>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JvFSt-0007dc-00@calista.eckenfels.net>
Date: Sun, 11 May 2008 19:36:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <4827227D.6040903@singnet.com.sg> you wrote:
> 1. What program should be used to see the FSINFO of a NFS server?

I think pathconf is supposed to do that, however I dont remember if it can
query filesize. I have seen only PATH_MAX und NAME_MAX on NFS>=3.

However you can strace that:

# strace getconf NAME_MAX /nfs/home
...
readlink("/usr/lib/getconf/default", 0xbf846ea6, 21) = -1 ENOENT (No such file or directory)
statfs("/nfs/home/", {f_type="NFS_SUPER_MAGIC", f_bsize=16384, f_blocks=3731367, f_bfree=454412, f_bavail=155902, f_files=7725054, f_ffree=7434759, f_fsid={0, 0}, f_namelen=255, f_frsize=16384}) = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f33000
write(1, "255\n") = 4
255

In my example the FreeBSD Server is not returning max filesize..

Gruss
Bernd
