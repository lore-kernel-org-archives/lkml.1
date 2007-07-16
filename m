Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbXGPJGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbXGPJGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbXGPJFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:05:54 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39430 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbXGPJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:05:53 -0400
To: jeremy@goop.org
CC: jengelh@computergmbh.de, viro@ftp.linux.org.uk, nmiell@comcast.net,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <469B2CAE.9010101@goop.org> (message from Jeremy Fitzhardinge on
	Mon, 16 Jul 2007 01:30:38 -0700)
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr> <469B2CAE.9010101@goop.org>
Message-Id: <E1IAMWA-0004fM-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 16 Jul 2007 11:05:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > fd1 = open("dir1", O_DIRECTORY):
> > fd2 = open("dir2", O_DIRECTORY);
> > system("mount -t tmpfs none dir1");
> > system("mount -t tmpfs none dir2");
> > openat(fd1, "file1", O_RDWR | O_CREAT);
> > openat(fd2, "file2", O_RDWR | O_CREAT);
> > If you have a better way to accomplish this, let me know. :)
> >   
> 
> This should work:
> 
>     fchdir(fd1);
>     open("file1", O_RDWR | O_CREAT);
>     fchdir(fd2);
>     open("file2", O_RDWR | O_CREAT);

If you only have a single thread, yes.

The *at() thing basically gives you the advantages of a CWD without
the disadvantages.

For example it could be useful to implement the functionality of
find(1) as a library interface.

Miklos
