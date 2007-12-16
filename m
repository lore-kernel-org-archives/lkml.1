Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbXLPWAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbXLPWAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763771AbXLPV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:59:48 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:35815 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763507AbXLPV7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:59:45 -0500
Date: Mon, 17 Dec 2007 06:59:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
Message-ID: <20071216215929.GA14278@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-sh@vger.kernel.org, axboe@kernel.dk
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com> <20071216095019.GA12184@linux-sh.org> <1197826371.6254.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197826371.6254.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 05:32:51PM +0000, Adrian McMenamin wrote:
> On Sun, 2007-12-16 at 18:50 +0900, Paul Mundt wrote:
> > > +	for (count = 0xa0000000; count < 0xa0200000; count += 4)
> > > +		ctrl_inl(count);
> > 
> > Er? This ranged dummy reading of the P2 space needs some explanation. The
> > GD-ROM isn't even mapped in to this space, so this seems like a hack to
> > either work around a timing issue or a write ordering problem.
> 
> I'll confess to not knowing what it's up to here either, other than it
> looks like a mechanism to cause a G1 bus reset. This is a progressive
> read of the Boot ROM area and that is all under G1 control (as is the GD
> Rom obviously)
> 
Ok, then this should be moved out to a g1_bus_reset() or something
similar with a comment explaining what it's doing, that way it can be
trivially reworked if a saner method of forcing a G1 reset is discovered.

While I realize that this is all undocumented and based entirely on
reverse engineering, you should at least verify that that's precisely
what is going on, and that this is not just a precaution for flushing
posted writes. You can test that by removing the loop and doing a dummy
read after your write (to the same register, rather than the entire ROM
space). If it's a posting issue, then you will have to do your own
read/write_reg routines that handle the flush.
