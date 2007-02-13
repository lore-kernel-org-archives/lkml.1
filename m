Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXBMP2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXBMP2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbXBMP2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:28:20 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:39425 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXBMP2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:28:20 -0500
Date: Tue, 13 Feb 2007 18:35:21 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace regressions (was: -mm merge plans for 2.6.21)
Message-ID: <20070213153521.GA6036@localhost.sw.ru>
References: <20070212125156.GA6035@localhost.sw.ru> <20070212213634.2777A1800E4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212213634.2777A1800E4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 01:36:34PM -0800, Roland McGrath wrote:
> > We're aware of two regressions compared to mainline if ptrace is utrace:
>
> Thanks very much for bringing these to my attention.
>
> > 1) zero holes for PTRACE_PEEKUSR vanished.
>
> I've fixed this in the current patches.

Looking at mainline x86_64 ptrace code I think hole for u_debugreg[4]
and [5] is also needed.

--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -687,6 +687,8 @@ EXPORT_SYMBOL_GPL(utrace_x86_64_native);
 #ifdef CONFIG_PTRACE
 static const struct ptrace_layout_segment x86_64_uarea[] = {
 	{0, sizeof(struct user_regs_struct), 0, 0},
+	{sizeof(struct user_regs_struct),
+	 offsetof(struct user, u_debugreg[0]), -1, 0},
 	{offsetof(struct user, u_debugreg[0]),
 	 offsetof(struct user, u_debugreg[4]), 3, 0},
 	{offsetof(struct user, u_debugreg[6]),

