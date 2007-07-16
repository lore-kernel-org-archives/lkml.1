Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXGPIbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXGPIbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXGPIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:31:43 -0400
Received: from gw.goop.org ([64.81.55.164]:57104 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbXGPIbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:31:41 -0400
Message-ID: <469B2CAE.9010101@goop.org>
Date: Mon, 16 Jul 2007 01:30:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Al Viro <viro@ftp.linux.org.uk>, Nicholas Miell <nmiell@comcast.net>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> fd1 = open("dir1", O_DIRECTORY):
> fd2 = open("dir2", O_DIRECTORY);
> system("mount -t tmpfs none dir1");
> system("mount -t tmpfs none dir2");
> openat(fd1, "file1", O_RDWR | O_CREAT);
> openat(fd2, "file2", O_RDWR | O_CREAT);
> If you have a better way to accomplish this, let me know. :)
>   

This should work:

    fchdir(fd1);
    open("file1", O_RDWR | O_CREAT);
    fchdir(fd2);
    open("file2", O_RDWR | O_CREAT);


    J
