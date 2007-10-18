Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbXJRUKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbXJRUKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbXJRUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:10:21 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:35133 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbXJRUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:10:20 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC PATCH 0/5] Shadow directories
Date: Thu, 18 Oct 2007 22:10:16 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200710181721.09201.jara@sin.cvut.cz> <200710181907.58643.jara@sin.cvut.cz> <Pine.LNX.4.64.0710181908240.22233@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710181908240.22233@fbirervta.pbzchgretzou.qr>
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710182210.17910.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 of October 2007, Jan Engelhardt wrote:
> >> >
> >> >The '^' is an escape character and it tells the computer to treat the file as a directory.
> >> 
> >> But what you could do is: write a FUSE fs that mirrors the lower content
> >> (lofs/fuseloop/however it was named) and expands .zip files as
> >> directories are readdir'ed or the zip files stat'ed. That saves us
> >> from cluttering up the Linux VFS with such stuff.
> >
> >Yes, that's exactly what RheaVFS and AVFS do. Except that they both use an escape
> >character because:
> >1. without it some programs may break [ http://lwn.net/Articles/100148/ ]
> >2. it's very useful to pass additional parameters after the escape char to the server.
> >
> >We can start VFS servers (mentioned above) and chroot the whole user session into
> >the mount directory of the server. It works but it's very slow, practically unusable.
> 
> Sounds like a program bug, since NTFS-3G is proof of concept that FUSE
> can be fast.
> 

Good point, I'll look onto it.

A minor implementation problem with chrooted environment is that the FUSE VFS server
must be run with root privileges to allow setuid programs on the mounted filesystems.
But it's certainly doable.


-- 
"Elves and Dragons!" I says to him.  "Cabbages and potatoes are better
for you and me."  -- J. R. R. Tolkien
