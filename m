Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXBVLLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXBVLLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXBVLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:11:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58567
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbXBVLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:11:53 -0500
Date: Thu, 22 Feb 2007 03:11:49 -0800 (PST)
Message-Id: <20070222.031149.112617356.davem@davemloft.net>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, vapier.adi@gmail.com
Subject: Re: <linux/socket.h>, <linux/stat.h> breakage: AF_* constants are
 part of ABI definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <45DA1154.9020601@zytor.com>
References: <45DA1154.9020601@zytor.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 19 Feb 2007 13:06:28 -0800

> In the current git tree, commit 57a87bb0720a5cf7a9ece49a8c8ed288398fd1bb 
> removes any way to automatically extracting a whole lot of ABI constants 
> from the kernel headers, especially AF_* and the various S_* constants.
> 
> Furthermore, the patch breaks <linux/in.h> which uses sa_family_t, which 
> is now defined under __KERNEL__.
 ...
> This patch breaks klibc in ways that are painfully hard to fix, and 
> *definitely* cannot be fixed by anything less than replication of all 
> these definitions, which is exactly the Wrong Thing[TM].
> 
> A much better solution (or complement) would be something like:
> 
> #if defined(__KERNEL__) || defined(__KHDR_CONSTANTS)
> 
> We could have __KHDR_CONSTANTS for the AF_* constants and __KHDR_MACROS 
> for the various macros (cmsg et al).  That way the userspace library can 
> ask for what it wants.

I'll think about what to do about this, thanks for pointing out
the problem.
