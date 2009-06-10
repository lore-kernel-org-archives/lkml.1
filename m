Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZFJAOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZFJAOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZFJAOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:14:32 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43278 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZFJAOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:14:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18990.64229.961985.491166@cargo.ozlabs.ibm.com>
Date: Wed, 10 Jun 2009 10:14:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
In-Reply-To: <4A2EED64.9070605@linux.vnet.ibm.com>
References: <1244490680.6691.1.camel@laptop>
	<4A2D8011.9050502@linux.vnet.ibm.com>
	<1244496223.6691.2.camel@laptop>
	<4A2D82CE.9000206@linux.vnet.ibm.com>
	<20090608215002.GB22049@elte.hu>
	<4A2DB1C6.6090209@linux.vnet.ibm.com>
	<20090609065117.GA16707@elte.hu>
	<4A2E19A9.3070201@linux.vnet.ibm.com>
	<20090609115346.GB3062@elte.hu>
	<4A2E9157.2030108@linux.vnet.ibm.com>
	<20090609220020.GA26526@elte.hu>
	<4A2EED64.9070605@linux.vnet.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> Ok, some disclosure here: we have not yet supported either of these features in 
> the Power PMU's in any open source code (and perhaps the proprietary code too, 
> but I don't know about that).  Since these features are described in an IBM 
> proprietary document, I can't describe how they work here, except to say that 
> they are present in the chip.

Actually, the public PPC970FX user manual has a chapter on the
performance monitor unit which describes both thresholding and the
instruction matching CAM, among other things.

I think we can support thresholding using higher-order bits of the
event code when the low bits == PM_THRESH_TIMEO.  We can only have one
PM_THRESH_TIMEO event on the PMU at any given time, so there can't be
any conflict over the thresholder settings.

The IMC is more problematic, but we can't do much with it on POWER5
and later processors anyway, due to various things being accessible
only in hypervisor mode, so I have been ignoring it. :)

Paul.
