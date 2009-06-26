Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZFZUeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZFZUeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZFZUdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:33:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3801 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZFZUdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:33:53 -0400
Subject: Re: [PATCH] PCAP RTC driver (for 2.6.32).
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, a.zummo@towertech.it,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       openezx-devel@lists.openezx.org, sameo@linux.intel.com
In-Reply-To: <20090626132310.60665a98.akpm@linux-foundation.org>
References: <1245962749.10360.42.camel@brutus>
	 <20090626132310.60665a98.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 13:33:34 -0700
Message-Id: <1246048414.18587.71.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 13:23 -0700, Andrew Morton wrote:
> > diff -puN /dev/null drivers/rtc/rtc-pcap.c
> > --- /dev/null
> > +++ a/drivers/rtc/rtc-pcap.c
[]
> > +static irqreturn_t pcap_rtc_irq(int irq, void *_pcap_rtc)
> > +{
> > +	struct pcap_rtc *pcap_rtc = _pcap_rtc;
> > +	unsigned long rtc_events = 0;
> > +
> > +	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
> > +		rtc_events |= RTC_IRQF | RTC_UF;
> > +	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
> > +		rtc_events |= RTC_IRQF | RTC_AF;
> > +
> > +	rtc_update_irq(pcap_rtc->rtc, 1, rtc_events);
> > +	return IRQ_HANDLED;
> > +}
> 
> This could be coded more simply:
> 
> 	unsigned long rtc_events;
> 
> 	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
> 		rtc_events = RTC_IRQF | RTC_UF;
> 	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
> 		rtc_events = RTC_IRQF | RTC_AF;

else
	rec_events = 0;

> > +     rtc_update_irq(pcap_rtc->rtc, 1, rtc_events);
> > +     return IRQ_HANDLED;

Does that buy any clarity?


