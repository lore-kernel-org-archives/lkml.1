Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZIOLZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZIOLZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZIOLZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:25:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZIOLZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:25:23 -0400
Subject: RE: [patch, resend] x86, perf_counter, bts: optimize BTS overflow
 handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC47B0E9E@irsmsx504.ger.corp.intel.com>
References: <20090915130023.A16204@sedona.ch.intel.com>
	 <1253013145.5506.50.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77EC47B0E9E@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 13:25:15 +0200
Message-Id: <1253013915.5506.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 12:18 +0100, Metzger, Markus T wrote:

> >> Restructure perf_counter sampling into sample creation and sample
> >> output.
> >> Prepare a single reference sample for BTS sampling and update the from
> >> and to address fields when draining the BTS buffer.
> >> Drain the entire BTS buffer between a single perf_output_begin() /
> >> perf_output_end() pair.
> >
> >Generally looks very nice, one thing though, why did you take regs out
> >of perf_sample_data, now you get to pass around one extra param..
> 
> 
> That is to make perf_sample_data describe the sample directly.
> 
> The regs are used to create the sample; they're not needed once
> the sample has been created.

True, but I'd have been lazy and not added that extra parameter all over
the place, but sure ;-)

This is now fast enough to BTS trace the kernel too?


