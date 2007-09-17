Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbXIQUpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbXIQUpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbXIQUpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:45:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759133AbXIQUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:45:18 -0400
Date: Mon, 17 Sep 2007 13:43:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: davidel@xmailserver.org, vda.linux@googlemail.com, rdunlap@xenotime.net,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, drepper@redhat.com, stable@kernel.org,
       hch@lst.de, jengelh@computergmbh.de, corbet@lwn.net
Subject: Re: [PATCH] remove timerd() syscall number
Message-Id: <20070917134315.968c1902.akpm@linux-foundation.org>
In-Reply-To: <46EEB252.30003@gmx.net>
References: <46EEB252.30003@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 18:58:58 +0200
Michael Kerrisk <mtk-manpages@gmx.net> wrote:

> I hope I've done this right...  This patch, against 2.6.23-rc6,
> removes the timerfd() syscall (which in any case had a bug
> on its 2.6.22 release) from all architectures, so that we
> can have some breathing space to think about the API design.
> All of the existing timerfd() code is left intact.

I think a minimally-intrusive implementation would be

--- a/fs/timerfd.c~a
+++ a/fs/timerfd.c
@@ -159,6 +159,8 @@ asmlinkage long sys_timerfd(int ufd, int
 	struct inode *inode;
 	struct itimerspec ktmr;
 
+	return -ENOSYS;
+
 	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
 		return -EFAULT;
 
_

or, better,

--- a/init/Kconfig~a
+++ a/init/Kconfig
@@ -491,6 +491,7 @@ config SIGNALFD
 
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
+	depends on BROKEN
 	select ANON_INODES
 	default y
 	help
_

