Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZIVHdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZIVHdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZIVHdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:33:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:38591 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZIVHdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:33:14 -0400
Date: Tue, 22 Sep 2009 09:33:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
In-Reply-To: <20090922055954.GB9658@core.coreip.homeip.net>
Message-ID: <alpine.LRH.2.00.0909220933090.27145@twin.jikos.cz>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> <20090922055954.GB9658@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Dmitry Torokhov wrote:

> > +	if (event & KP_INT) {
> > +		adp5520_read(dev->master, KP_INT_STAT_1, &reg_val_low);
> > +		adp5520_read(dev->master, KP_INT_STAT_2, &reg_val_high);
> > +
> > +		keymask = (reg_val_high << 8) | reg_val_low;
> > +		/* Read twice to clear */
> > +		adp5520_read(dev->master, KP_INT_STAT_1, &reg_val_low);
> > +		adp5520_read(dev->master, KP_INT_STAT_2, &reg_val_high);
> > +		keymask |= (reg_val_high << 8) | reg_val_low;
> > +		adp5520_keys_report_event(dev, keymask, 1);
> > +	}
> > +
> > +	if (event & KR_INT) {
> 
> Why do you check the same condition twice?

It actually doesn't seem to be the same condition (KP_INT vs. KR_INT), but 
it's difficult to say, as these constants are apparently added in some 
other patch I have no idea about.
And the same for other constants used in the code ... the patch seems to 
be quite incomplete.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

