Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYCJU2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYCJU2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYCJU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:27:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYCJU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:27:58 -0400
Message-ID: <47D59743.7040709@zytor.com>
Date: Mon, 10 Mar 2008 21:17:07 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: P6 NOPs again: MPSC?
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site> <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com> <Pine.LNX.4.64.0803101853090.15511@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803101853090.15511@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I've now noticed that the machine I call MPENTIUM4 for 32-bit kernels
> is called MPSC for 64-bit kernels, and in that case it still doesn't
> get the P6 NOPs which I'm guessing it ought to (yeah, I'm so excited
> about the speedup I can expect from P6 NOPs, can we perhaps have a
> little silvery "Using Genuine P6 NOPs" sticker to put on the box? ;)
> 
> I'm suspecting that the patch below is actually wrong, and that it's
> really the "(X86_64 || !X86_GENERIC) &&" which should be changed;
> but very unsure of my ground and what's right for CPU_GENERIC -
> the 32/64 heritage of x86/Kconfig.cpu rather confuses me.
> 
> Over to you to do the right thing, I'm hoping, please, Peter!
> 

X86_64 && !X86_GENERIC comes from not wanting to be a compatibility 
issue when compiling for generic CPUs.  There are some 32-bit otherwise 
i686-compatible chips (from VIA and Transmeta) which don't have these NOPs.

	-hpa

