Return-Path: <linux-kernel-owner+w=401wt.eu-S1767742AbXEDJYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767742AbXEDJYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767750AbXEDJYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:24:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46615 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767758AbXEDJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:24:08 -0400
Subject: Re: [linux-dvb] Re: DST/BT878 module customization
	(..	was:	Critical points about ...)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Markus Rechberger <mrechberger@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <Pine.LNX.4.58.0705032123340.32689@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	 <1178031333.3958.63.camel@localhost>
	 <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
	 <1178071431.11109.62.camel@localhost>
	 <Pine.LNX.4.58.0705020348080.309@shell2.speakeasy.net>
	 <1178200976.12651.104.camel@localhost>
	 <Pine.LNX.4.58.0705032123340.32689@shell2.speakeasy.net>
Content-Type: text/plain
Date: Fri, 04 May 2007 06:23:34 -0300
Message-Id: <1178270614.12651.303.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would be nice, however, to have a patch making dvb_attach more
> > generic, by e.g. having a variant that allows passing another message.
> 
> Only this message is from dvb_attach():
> > DVB: Unable to find symbol dst_attach()
> 
> Is it saying that it cannot load the module that dst_attach() is in (it
> doesn't know what module that is, modprobe knows that).  If you enabled dst
> support and deleted the module, it would be the same.
> 
> If you turn off dvb_attach() and also disable dst, you should instead get
> this message:
> dst_attach: driver disabled by Kconfig
> 
> Maybe that would look nicer with a "DVB:  " prefix?  That would easier if it
> wasn't necessary to update the printk in each boilerplate stub function.  What
> if one macro created these stubs....
> 
> > frontend_init: Could not find a Twinhan DST.
> > dvb-bt8xx: A frontend driver was not found for device 109e/0878 subsystem fbfb/f800
> 
> These two messages are printed by the dvb-bt8xx driver, not by dvb_attach().
> It would be trivial to change of course, but I'm not sure what would be
> pedantically correct for both dst and non-dst based hardware.

Sorry, this is what I meant: to fix the above message. The dvb_attach is
generic enough.

Maybe a more nice text would be something like:
	"Couldn't initialize frontend helper modules for device ..."

since dvb_attach will also print what modules were not loaded.
> 
> > There's an argument against the prototype changes on dst_attach and
> > dst_ca_attach since they aren't frontend.
> 
> The reason I changed that, is the dst_attach() already did return a
> dvb_frontend pointer, it was just inside an enclosing structure.  i.e. what
> existed before:
> 
> {
> 	struct dst_state *state;
> 	state = dst_attach(...);
> 	card->fe = &state->frontend;
> } /* state goes out of scope */
> 
> The frontend is inside the state struct and the state pointer isn't saved
> anywhere.  dvb-bt8xx just saves a frontend pointer from inside the dst state
> and tosses the state pointer away.  So I changed that to:
> 
> 	card->fe = dst_attach(...);

IMO, this made the code cleaner.

-- 
Cheers,
Mauro

