Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYL3V3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYL3V3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYL3V3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:29:06 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58703 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752540AbYL3V3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:29:05 -0500
Date: Tue, 30 Dec 2008 15:29:03 -0600
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Message-ID: <20081230212903.GB19653@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20081227155019.GA15493@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227155019.GA15493@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 04:50:19PM +0100, Ingo Molnar wrote:
> 
> If we want to enable userspace to capture MCE events, then it must be done 
> in a way that benefits the whole kernel, not just x86: a structured 
> logging facility that is in essence a printk variant and is ASCII driven. 

It would be very useful to implement error handling in a way
that has an arch independed framework.  ia64 has already
implemented much of this functionality.

> Such event sources should be discoverable, and only 'aware' printouts 
> should go into this new facility (not all printks). Demultiplexing should 
> be easy and well-defined.
> 
> I.e. we could use this opportunity of the MCE code unification to bring 
> the code to the next level - and not prolongue to broken concepts of the 
> past.
> 
> I'd be glad to help out with any portion of this, it should be easy to 
> solve and it will clearly improve the code. For .29 we could just do a raw 
> printk based approach with no decoding just yet, and layer smart decoding 
> and structured logging for .30.
> 
> Hm?

Something along those lines, though I would support more of
Andi's code getting in for .29 (even if it means putting code
into .29 and then changing it for .30).  It will take time to
come up with a cross arch framework, longer than the .29
merge window.

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
