Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYKYKpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYKYKpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYKYKpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:45:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53881 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYKYKpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:45:06 -0500
Date: Tue, 25 Nov 2008 10:45:04 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: petkovbb@gmail.com, bzolnier@gmail.com, sshtylyov@ru.mvista.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081125104504.GA6543@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie> <20081124225139.GA26953@gollum.tnic> <20081125000102.GC8293@csn.ul.ie> <20081125072156.GA3771@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081125072156.GA3771@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 08:21:56AM +0100, Borislav Petkov wrote:
> [.. ]
> 
> > > And the probing _is_ done when loaded as a module so the problem is
> > > not with the mask - in your case the probing will work just fine as
> > > you need ide0 and ide1, AFAICT.
> > 
> > Out of curiousity, I loaded ide-generic as a module and tried the suggested
> > probe_mask. It loads after e100 which is built in and then has a crap attack
> > as it tries to register IO regions which are already registered, triggers
> > sysfs warnings for creating duplicate files and then continues along to
> > a state where networking doesn't work anyway. That suggestion of 0x3f may
> > still catch someone.
> 
> Yep, the message could be misleading wrt to the probe_mask. Is something
> along the lines of
> 
> "please adjust the probe_mask module parameter for probing the rest of the
> legacy ISA IDE ports"
> 
> more informative? Now it implies that the primary/secondary ports are
> probed by default.
>

It's slightly better as it doesn't imply 0x3F is the right value in all
cases. It would be nice that some valid values are then documented
somewhere, be it in the modinfo information or
Documentation/ide/ide-generic.txt?

However, as this was clearly a PEBKAC problem of me loading the totally
wrong driver, maybe it's not worth the time.
 
> However, you still have to set it to something > 0x3 if you want to
> probe ide[2-5]. Also, there's still the option of CONFIG_BLK_DEV_GENERIC
> which adds support for otherwise unsupported IDE PCI controllers.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
