Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYBIOzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYBIOzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYBIOzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:55:48 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:21369 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYBIOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:55:47 -0500
Date: Sat, 9 Feb 2008 15:55:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Only do century BCD conversion when we know the RTC is BCD
Message-ID: <20080209145545.GA6773@basil.nowhere.org>
References: <20080208114.066167427@suse.de> <alpine.LFD.1.00.0802091108170.3145@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802091108170.3145@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Feb 2008 14:49:24.0861 (UTC) FILETIME=[F68292D0:01C86B2A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 11:28:01AM +0100, Thomas Gleixner wrote:
> On Fri, 8 Feb 2008, Andi Kleen wrote:
> 
> > 
> > Minor logic fix. The century change was previously always BCD,
> > even when the CMOS data would report itself not being BCD.
> 
> Where was it previously always BCD ?
> 
> The code flow is taken 1:1 from the original x8664 code. Just the
> BCD_TO_BIN code has been made conditional for i386, which is not
> chanining the logic at all, because RTC_ALWAYS_BCD is always true on
> x8664.

Ah that's true -- i missed that indeed. I don't actually 
remember why it was hardcoded like this on x86-64. I don't think
there is a good reason for it and if there's a bit for this
in the CMOS it ought be better checked.

> 
> While your change does not do any harm due to BCD_TO_BIN(0) = 0, it
> is just not fixing anything.

In theory it would make sense with the followup change to
do the extended century on 32bit too, but in practice all these
systems should be BCD anyways (I hope) 


-Andi
