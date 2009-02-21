Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZBUCOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZBUCOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 21:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZBUCOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 21:14:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbZBUCOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 21:14:06 -0500
Date: Fri, 20 Feb 2009 18:13:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20090219171005.GA27922@elte.hu>
Message-ID: <alpine.LFD.2.00.0902201809260.21686@localhost.localdomain>
References: <20090219171005.GA27922@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Feb 2009, Ingo Molnar wrote:
>
> Andi Kleen (3):
>       x86, mce: reinitialize per cpu features on resume

This one causes

  WARNING: arch/x86/kernel/cpu/mcheck/built-in.o(.text+0xf72): Section mismatch in reference from the function mce_resume() to the function .cpuinit.text:mce_intel_feature_init()
  The function mce_resume() references
  the function __cpuinit mce_intel_feature_init().
  This is often because mce_resume lacks a __cpuinit annotation or the annotation of mce_intel_feature_init is wrong.

which looks like a real bug.

On UP - withot CPU hotplug - I think __cpuinit becomes __init. No? So now 
mce_resume() will call some function that was long since free'd.

I didn't look closer, but I wish somebody else would. And I wish people 
looked at warnings that are introduced by their new code before sending 
said changes to me.

		Linus
