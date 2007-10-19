Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXJSQT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXJSQT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXJSQTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:19:48 -0400
Received: from www.tglx.de ([62.245.132.106]:56595 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbXJSQTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:19:47 -0400
Date: Fri, 19 Oct 2007 18:19:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlos Corbacho <cathectic@slackadelic.com>
cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: nVidia HPET force enable - merge requirements? (resend)
In-Reply-To: <200710191629.11526.cathectic@slackadelic.com>
Message-ID: <alpine.LFD.0.9999.0710191736280.22770@localhost.localdomain>
References: <200710190423.31714.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710190847500.22770@localhost.localdomain> <200710191629.11526.cathectic@slackadelic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Carlos Corbacho wrote:
> Would the following patch be more acceptable then? I've limited the device
> id's to just the nForce 4 chipset, because that's the only one I have here
> to test with at the moment - it appears to work fine:

Yes, looks good. It is just missing the resume part, which is
necessary to reenable the hpet after suspend/resume.
 
> hpet clockevent registered
> hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> Time: hpet clocksource has been installed.
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 1
> 
> At the moment, I'm not clear on how to detect if the HPET has not been
> enabled by the BIOS (but given that this is hidden behind hpet=force,
> would this be acceptable, since the user would have to explicitly call
> hpet=force, and then it either works or doesn't?)

Don't worry. If HPET is enabled in the BIOS, then we have an
hpet_address already before we come into the force enable
quirk. That's why we check for hpet_address in the quirk code.

     tglx

