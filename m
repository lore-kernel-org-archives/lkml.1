Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYGYAyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYGYAyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYGYAx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:53:59 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:35347 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753554AbYGYAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:53:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=eGQuWbZtdY1ioCxWWdkp3M+RuFplxV079c2mh9Eiya8M9bZr0g4OA50J5ijIE+/V5VFj4tSTqfuqtxSphNqShMI7Zjaq2usUr0tlT5olB0Xm7Q1XYLcW3tFq8TrerYSH499bHTZEHiWh/psfgyAvROw0QQbUyokbLvR0ZFRhJyg=  ;
X-YMail-OSG: CJeyMK4VM1mrgcqIEWnS30a7ExQb4m451aEFJln9Fo.mlfEOJT2y2fOdzxwlNw06JjJCDeKGKcDZuc9Kdp0b4OXsVBFgNMg4ouEaP_3z6Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 0/0] Power domain and clock domain patches for omap
Date: Thu, 24 Jul 2008 17:53:56 -0700
User-Agent: KMail/1.9.9
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, linux-pm@lists.linux-foundation.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1216221555-18958-1-git-send-email-tony@atomide.com> <20080721222908.GF18909@flint.arm.linux.org.uk>
In-Reply-To: <20080721222908.GF18909@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200807241753.56893.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2008, Russell King - ARM Linux wrote:
> On Wed, Jul 16, 2008 at 06:19:05PM +0300, Tony Lindgren wrote:
> > I'm reposting the series to a wider audience as Russell King suspected that
> > other archs may be interested in reviewing these too, or at least some
> > parts of the code.
> 
> It would be nice to have some comment on these patches from other
> people.  My suspicions is that this infrastructure is solving a
> problem found on other SoCs in addition to OMAP,

ISTR that DaVinci is similar ... but much simpler, with fewer
power domains and more are "always on".  Not much of the DaVinci
support is upstream yet though.

I'm not sure how many non-TI parts will need similar software
support.  It's my understanding that not many vendors put
that much energy into support for leakage current management.

(Here, a key observation is that when a section of a chip has
gated all its clocks off, that leaves leakage current as the
top source of power wastage.  Cooperative drivers could then
let that section be powered down to eliminate leakage.  So the
first level of power management is clock gating, at least in
part with software support.  The power domain gating is a
second level.)


The "regulator" stuff is not unrelated ... except that this
power domain stuff *only* needs on/off switches (like almost all
power domains I've ever used), is tightly coupled to clocks,
and unlike "regulators" is more oriented towards SOC-internal
concerns than board-level ones.


> and, if this is 
> useful to other people, it should become cross-SoC infrastructure.

My two cents:  merge the OMAP stuff first, then see what kinds
of generalization would be needed before other chips could use it.

Nobody wins by holding this back ... but everyone on OMAP2/OMAP3
loses.

- Dave



> Since I don't know the answer to whether it would be useful, I'm
> trying to ensure that these patches have sufficient exposure to
> people who _may_ know the answer.
