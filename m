Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYGUEd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYGUEd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYGUEdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:33:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:60826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYGUEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:33:19 -0400
Date: Sun, 20 Jul 2008 14:33:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
 all devices to init
Message-ID: <20080720143302.118bfac4@infradead.org>
In-Reply-To: <18564.4308.219240.133199@notabene.brown>
References: <20080720151140.4aa7c682@infradead.org>
	<20080720151339.6f4a83d8@infradead.org>
	<18563.50428.659101.868745@notabene.brown>
	<20080720163126.64b39d50@infradead.org>
	<18564.4308.219240.133199@notabene.brown>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 14:30:12 +1000
Neil Brown <neilb@suse.de> wrote:

> 
> > +		while (driver_probe_done())
> >  			msleep(100);
> 
> That's worse.  Now it really looks like a boolean that is being used
> wrongly.  It seems that driver_probe_done either returns 0 or -EBUSY,
> so I'd prefer
> 
> > +		while (driver_probe_done() < 0)
> >  			msleep(100);
> 
> or even

ok I've done this one.

I'll be the first to say that this driver_probe_done() isn't very
elegant.. but it's out of my current scope to rewrite that whole
thing ... I'll leave that to GregKH.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
