Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbYJFG7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbYJFG7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYJFG7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:59:32 -0400
Received: from www.tglx.de ([62.245.132.106]:57972 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbYJFG7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:59:32 -0400
Date: Mon, 6 Oct 2008 08:59:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: aim7 47% regression with 2.6.27-rc8
In-Reply-To: <1223269135.1685.11.camel@ymzhang>
Message-ID: <alpine.LFD.2.00.0810060858350.3398@apollo>
References: <1223269135.1685.11.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Zhang, Yanmin wrote:
> Comparing with 2.6.27-rc8, aim7 result has about 47% regression with 2.6.27-rc8 on
> my 16-core tigerton and 8 core+HyperThreading x86_64 machine.
> 
> I bisected it down to patch:
> 
> 302745699c1b675b5d2a1af87271de10e4d96b6a is first bad commit
> commit 302745699c1b675b5d2a1af87271de10e4d96b6a
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Sep 22 19:02:25 2008 +0200
> 
>     clockevents: check broadcast device not tick device
>     
>     Impact: Possible hang on CPU online observed on AMD C1E machines.
>     
>     The broadcast setup code looks at the mode of the tick device to
>     determine whether it needs to be shut down or setup. This is wrong
>     when the broadcast mode is set to one shot already. This can happen
>     when a CPU is brought online as it goes through the periodic setup
>     first.
>     
>     The problem went unnoticed as sane systems do not call into that code
>     before the switch to one shot for the clock event device happens.
>     The AMD C1E idle routine switches over immediately and thereby shuts
>     down the just setup device before the first interrupt happens.
> 
> 
> After I reverted the patch against 2.6.27-rc8, the regression disappears.
> It's interesting that the regression doesn't exist on 8-core stoakley.

There is a fixup patch for this one after rc8. 07454bfff151d2465ada809bbaddf3548cc1097c
Can you check with this one applied please ?

Thanks,

	tglx
