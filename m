Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbXENRwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbXENRwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbXENRwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:52:09 -0400
Received: from mail.lysator.liu.se ([130.236.254.3]:42208 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbXENRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:52:08 -0400
X-Greylist: delayed 1881 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 13:52:07 EDT
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.21.1 early putstr() fails on ARM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: =?iso-8859-1?Q?Mattias_R=F6nnblom?= <hofors@lysator.liu.se>
Date: 14 May 2007 19:14:56 +0200
Message-ID: <87d51372en.fsf@isengard.friendlyfire.se>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I just tried updating Linux 2.6.16 to 2.6.21.1 on our IXP420-based
board, but I've run into some trouble. Except for some modifications
to the PCI setup code, the tree is unmodified. GCC is 3.4.3 and
Binutils 2.15.94.

During the decompression stage, the kernel "Uncompressing Linux..."
printout is garbled. When digging into this I found that the string
passed to putstr() is not "Uncompressing Linux...", but rather
something much longer containing a lot of unprintable characters.
putc() as such works fine, and putting "putc('A');" into the
decompress_kernel function (arch/arm/boot/compressed/misc.c), for
example, prints a nice "A" on the console.

>From what limited experience I have of these sorts of things I came to
the conclusion that maybe the linking wasn't done correctly. But
replacing the previously mentioned toolchain with CodeSourcery's
pre-built GCC 4.2.0 and Binutils 2.17 didn't make any difference.

Besides our old (and working, on 2.6.16) .config, I've been trying all
kinds of configs (including ixp4xx_defconfig) without success.

What might I be doing wrong? Any help is appreciated.

Regards,
        Mattias

