Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYHVADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYHVADU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYHVADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:03:07 -0400
Received: from gw.goop.org ([64.81.55.164]:55435 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYHVADG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:03:06 -0400
Message-ID: <48AE022F.6030100@goop.org>
Date: Thu, 21 Aug 2008 17:02:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>	 <48ADFB33.8010204@goop.org>	 <86802c440808211649h37ac7533q4b95a83306ecd430@mail.gmail.com>	 <48ADFFD2.7030309@goop.org> <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com>
In-Reply-To: <86802c440808211656o20f9a22dv34e3ac8e8e84b4e1@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> like system vectors with smp-ipi etc?
>   

More or less.  Xen currently uses 6 per-cpu event channels, and it maps
each to its own irq.  My plan is to allocate just 6 irqs, map 6 vectors
to them, and bind each event channel to a vector/cpu pair.  If nothing
else, it will make /proc/interrupts somewhat sane again.


>> Also, implementing probe_nr_irqs() in a more generic (rather than
>> io_apic-specific) way.  Using some interface that queries each irq chip
>> for how many irqs it supports, or something.
>>     
>
> hope we can kill nr_irqs/NR_IRQS
>   

When irqs are truely dynamically allocated?

    J
