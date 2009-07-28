Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZG1Ppg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZG1Ppg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZG1Ppf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:45:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:32842 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752159AbZG1Ppf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:45:35 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18eMMVZYAkemPCQ1BCV1Q2VuiiB4XvE4Z6tZxVulk
	PkdMZl6hzxnE1u
Date: Tue, 28 Jul 2009 17:45:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
In-Reply-To: <4A6F0123.9040809@mnementh.co.uk>
Message-ID: <Pine.LNX.4.64.0907281556160.6219@axis700.grange>
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
 <4A6F0123.9040809@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Ian Molton wrote:

> Guennadi Liakhovetski wrote:
> > If the platform device has a clock associated with the tmio-mmc device, use
> > it.
> 
> Sorry, I misread there.
> 
> I'm still not sure what to to about this though because we seem to be
> collecting numerous ways of passing clocks to this driver, this is the fourth,
> by my counting.
> 
> the clock API could cope with all of them by simply allowing the driver to
> claim CLK_MMC (or such) from its parent, except that it cant cope with both
> the platform and MFD code providing clocks. The parent could be either the
> TMIO MFD core (for TMIO MFDs) or the CPU/SoC whatever, it woudlnt matter.
> 
> In any case, still no, as with all the other TMIO clock code patches. This
> needs to be done properly.

Hi Ian

Thanks for the review.

I understand your concerns. Of course, the _proper_ solution would be to 
implement an architecture-independent clock API, something like what 
clocklib was trying to do. So, yes, if clocklib were in place now, I 
certainly would have used it.

I searched for those clocklib submission attempts (Dmitry added to CC). 
Last one I can find (maybe I missed some) is from July 2008 - more than a 
year ago. So, looks like our options currently are:

1. wait for new submissions of clocklib - if any are planned
2. develop a completely new arch-independent clock API approach
3. take over patches from Dmitry and bring them to a state acceptable for 
mainline

(any more I missed)

No idea about 1, hopefully, Dmitry can tell if he has any near future 
plans to resubmit his patches.

I personally don't have free (as in beer) time to work on 2 or 3. Anyone?

So, unless we hear, that one of the 1-3 is going to happen real soon now, 
I think, it would be unfair to leave SuperH without a proper MMC driver in 
the mainline for an indefinite time, when one can be trivially achieved.

As for your debugging concern, we could allow configuration-less operation 
only on SuperH in tmio_mmc, how about that?

Thanks
Guennadi
---
Guennadi Liakhovetski
