Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbYBML0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbYBML0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYBML0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:26:11 -0500
Received: from mail.suse.de ([195.135.220.2]:50952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbYBML0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:26:09 -0500
Message-ID: <47B2D41E.6040908@suse.de>
Date: Wed, 13 Feb 2008 12:27:26 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] CPA: Fix set_memory_x for ioremap v2
References: <20080212153.888987414@suse.de> <alpine.LFD.1.00.0802122318090.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802122318090.12988@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> The so-called "significant restructuring" took a mere 2 hours,
> which is probably less than the time consumed in this thread.

Hmm, it doesn't do what I meant and I don't think you solved
the problem. You still check against the vaddrs
which won't work for ioremaps or fixmap (and thus not
fix the EFI cases)

What I meant with restructuring is calling lookup_address() early,
get the physical address from the PTE, then check that against
the alias ranges in physical. That would actually work for fixmaps
and ioremaps and all other mappings too.

I'm sure it can be all done, but for me it to submit such
a change would likely require weeks of thread like this so
I'm not trying.

-Andi
