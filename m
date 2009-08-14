Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZHNHXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZHNHXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 03:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZHNHXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 03:23:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:58907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZHNHXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 03:23:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,379,1246863600"; 
   d="scan'208";a="541297512"
Subject: Re: [patch] clockevents_notify() need to be called with irq's
 enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain>
References: <1250203681.27006.10842.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 14 Aug 2009 00:26:18 -0700
Message-Id: <1250234778.2965.8.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 23:05 -0700, Thomas Gleixner wrote:
> On Thu, 13 Aug 2009, Suresh Siddha wrote:
> 
> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > Subject: clockevents_notify() need to be called with irq's enabled
> > 
> > Currently clockevents_notify() is called with interrupts enabled at some
> > places and interrupts disabled at some other places.
> 
> The only place I can see which calls clockevents_notify with
> interrupts enabled is the hrtimer cpu hotplug code.
> 
> I'm a bit wary to enable interrupts all over the place in sensitive
> corners like ACPI idle code ...
> 
> Why don't we just do the obvious and take clockevents_lock irqsave ?

We didn't go that route because of the smp_call_function() in the cpu
hotplug code. So we can't disable interrupts in that path.

ACPI idle code changes were ok'd by Venki. We did 4 or so hours testing
with our patch. Will do more testing in the coming days.

thanks,
suresh

