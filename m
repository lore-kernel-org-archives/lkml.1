Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbXHUGdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbXHUGdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbXHUGdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:33:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60138 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbXHUGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:33:22 -0400
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
In-Reply-To: <alpine.LFD.0.999.0708202325350.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
	 <200708202102.58508.david-b@pacbell.net>
	 <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
	 <200708202148.45575.david-b@pacbell.net>
	 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
	 <1187675488.2676.3.camel@laptopd505.fenrus.org>
	 <1187676254.2676.6.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.999.0708202325350.30176@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 20 Aug 2007 23:28:05 -0700
Message-Id: <1187677685.2676.12.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-20 at 23:26 -0700, Linus Torvalds wrote:
> 
> On Mon, 20 Aug 2007, Arjan van de Ven wrote:
> > 
> > untested patch to add this to cpufreq; this is probably a good idea in
> > general even if using the latency framework doesn't end up being used
> > for fixing this regression...
> > 
> > 
> > --- linux-2.6.23-rc2/drivers/cpufreq/cpufreq.c.org	2007-08-20 22:58:32.000000000 -0700
> > +++ linux-2.6.23-rc2/drivers/cpufreq/cpufreq.c	2007-08-20 23:02:21.000000000 -0700
> > @@ -1604,6 +1604,12 @@ static int __cpufreq_set_policy(struct c
> >  	if (ret)
> >  		goto error_out;
> >  
> > +
> > +	if (system_latency_constraint() < policy->cpuinfo.transition_latency) {
> 
> That looks broken. "system_latency_constraint()" is in us, but 
> transition_latency is in ns, afaik.
> 
> But adding a "/ 1000" to turn the ns into us, and it migth even work.


eh woops yes indeed.
Shows me for not testing; I'll do that tomorrow when I'm more awake
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

