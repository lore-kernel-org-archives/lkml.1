Return-Path: <linux-kernel-owner+w=401wt.eu-S1761711AbYESR3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761711AbYESR3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbYESR3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:29:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14563 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbYESR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:29:45 -0400
Date: Mon, 19 May 2008 10:29:20 -0700
From: Randy Dunlap <randy.dunlap@ORACLE.COM>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-Id: <20080519102920.fe46d7b5.randy.dunlap@oracle.com>
In-Reply-To: <20080519123111.97C0C1B41FF@basil.firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
	<20080519123111.97C0C1B41FF@basil.firstfloor.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 14:31:11 +0200 (CEST) Andi Kleen wrote:

> Index: linux/Documentation/filesystems/vfs.txt
> ===================================================================
> --- linux.orig/Documentation/filesystems/vfs.txt
> +++ linux/Documentation/filesystems/vfs.txt
> @@ -755,6 +755,7 @@ struct file_operations {
>  	int (*fsync) (struct file *, struct dentry *, int datasync);
>  	int (*aio_fsync) (struct kiocb *, int datasync);
>  	int (*fasync) (int, struct file *, int);
> +	int (*unlocked_fasync) (int, struct file *, int);
>  	int (*lock) (struct file *, int, struct file_lock *);
>  	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
>  	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
> @@ -814,7 +815,9 @@ otherwise noted.
>    fsync: called by the fsync(2) system call
>  
>    fasync: called by the fcntl(2) system call when asynchronous
> -	(non-blocking) mode is enabled for a file
> +	(non-blocking) mode is enabled for a file. BKL hold

?                                                  BKL is held.

> +
> +  unlocked_fasync: like fasync, but without BKL
>  
>    lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
>    	commands


---
~Randy
