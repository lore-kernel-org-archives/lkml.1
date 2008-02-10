Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYBJMSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYBJMSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYBJMSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:18:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37411 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYBJMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:18:11 -0500
Date: Sun, 10 Feb 2008 13:18:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [10/19] ftrace: add basic support for gcc profiler instrumentation
In-Reply-To: <20080210072035.GK4100@elte.hu>
Message-ID: <Pine.LNX.4.64.0802101315390.7176@fbirervta.pbzchgretzou.qr>
References: <20080210072035.GK4100@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 10 2008 08:20, Ingo Molnar wrote:
>--- linux.orig/Makefile
>+++ linux/Makefile
>@@ -509,6 +509,9 @@ endif
> 
> include $(srctree)/arch/$(SRCARCH)/Makefile
> 
>+ifdef CONFIG_FTRACE
>+KBUILD_CFLAGS	+= -pg
>+endif
> ifdef CONFIG_FRAME_POINTER
> KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> else

You should use -fno-omit-frame-pointer when building with -pg; As far
as I can remember from using gprof in the past (in userspace, I might
add), the output does not make much sense without frame boundaries.
