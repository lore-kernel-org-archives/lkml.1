Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbYCEGDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbYCEGDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYCEGDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:03:30 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:60892 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYCEGD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:03:29 -0500
Date: Wed, 5 Mar 2008 07:02:01 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Dave Jones" <davej@codemonkey.org.uk>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "LKML" <linux-kernel@vger.kernel.org>, "Adam Belay" <abelay@novell.com>,
       "Lee Revell" <rlrevell@joe-job.com>,
       linux-pm@lists.linux-foundation.org, "Pavel  Machek" <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305070201.0d16cd40@mjolnir.drzeus.cx>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 11:01:28 -0800
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> >
> >(On that subject, does anyone except Adam understand that 
> >algorithm? Some comments wouldn't hurt...)
> 
> Prediction is based on cumulative time till "non expected wakeup". So,
> prediction will come into play only when there are very short wakeups
> due to "unexpected wakeups".
> 

Ah, so the measured_us and elapsed_us are trying to keep track of time between non-timer wakeups?

> >So for now, I'm back to thinking that measuring the interval 
> >between deep sleeps is the better approach. I could use some 
> >ideas for a good clock source though. I haven't dug much 
> >deeper than jiffies when it comes to kernel timekeeping.
> 
> I think best solution is to use get_last_residency that is already
> there. If the last residency or expected_us is very low, you can avoid
> deep idle states. That way you don't have to depend on jiffies being
> updated at the time you are checking it.
> 

I tried using predicted_us and last_measured_us, and those didn't work (see the #if 0 code in my last patch). And since cpuidle_get_last_residency() is part of predicted_us, I don't think it is reporting useful values.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
