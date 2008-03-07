Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYCGXU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYCGXU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYCGXUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:20:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYCGXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:20:11 -0500
Date: Fri, 7 Mar 2008 15:18:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64 ptrace orig_ax on ia32 task
In-Reply-To: <20080307225602.6491B26F990@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803071507240.3013@woody.linux-foundation.org>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080307225602.6491B26F990@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Mar 2008, Roland McGrath wrote:
> 
> This makes 64-bit ptrace calls setting the 64-bit orig_ax field
> for a 32-bit task sign-extend the low 32 bits up to 64.  This
> matches what a 64-bit debugger expects when tracing a 32-bit task.

Hmm. Why make this conditional on CONFIG_IA32_EMULATION and TIF_IA32?

That field is never really 64-bit anyway. The only allowable values are
 - system call number (== small positive value)
 - a small negative number for traps

So I'd suggest just making it entirely unconditionally just do

	case offsetof(struct user_regs_struct, orig_ax):
		value = (long) (s32) value;
		break;

and be done with it. Why have arbitrarily different code on x86 and x86-64 
when there is no real reason for it?

		Linus
