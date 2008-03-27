Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYC0QQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYC0QQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbYC0QQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:16:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60114 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756313AbYC0QQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:16:10 -0400
Date: Thu, 27 Mar 2008 11:16:09 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
In-Reply-To: <20080326222450.GA11621@elte.hu>
Message-ID: <Pine.SGI.3.96.1080327110732.7873204d-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> well, i dont it has to be (or it should be) an all or nothing patch, 
> given the complexity and risks involved.
> 
> - we should first introduce a nr_irqs variable and a Kconfig switch 
>   (say CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS) for architectures to toggle. If 
>   the switch is toggled, nr_irqs is a variable, otherwise it's a carbon 
>   copy of NR_IRQS. Some array-definition, declaration and initialization 
>   wrappers are provided as well.
> 
> - then the core code, x86 and most drivers can be converted to nr_irqs.
>   The switch might initially even be user-selectable if
>   CONFIG_DEBUG_KERNEL, to ease regression testing.
> 
> - other architectures will follow one by one, fixing their
>   arch-dependent drivers as well in the process
> 
> - finally we get rid of the wrappers.
> 
> 	Ingo
> 

Okay, let's see if I understand this.

First patch introduces a config switch and a variable, nr_irqs that is
set to NR_IRQS.  It also dynamically allocates the currently staticly
allocated arrays that are dimensioned by NR_IRQS.  It also initializes
these dynamically allocated data structures.  This is all done under
the config switch, initially off by default.  

Second patch changes core code, x86 and most drivers to use nr_irqs.
This patch will also introduce a calculation of nr_irqs, based on
interrupt sources, that is a better estimate of the number of irqs
in the running system than just picking a guaranteed not-to-exceed
value that may be too big.
Is there a way to identify which drivers need to be addressed?

Then, test the crap out of it.  

Other architectures will follow, with the work being done by people
familiar with those architectures.

Clean up anything that's left over that's now been made unnecessary by
the conversion by everyone.  Including the config option?

Do I have the gist of it?

		--ajm

We are star dust,
We are golden,
We are caught in the Devil's bargain.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

