Return-Path: <linux-kernel-owner+w=401wt.eu-S1030236AbXFHLsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030236AbXFHLsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968159AbXFHLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:48:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54522 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967862AbXFHLsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:48:36 -0400
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
	used
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070608124853.5fdfaee2@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
	 <20070606160310.27d6d3b8@the-village.bc.nu>
	 <1181150998.2785.13.camel@pmac.infradead.org>
	 <20070607163808.19984208@the-village.bc.nu>
	 <1181231421.2785.68.camel@pmac.infradead.org>
	 <20070607225528.0d5e7b29@the-village.bc.nu>
	 <1181254517.20322.6.camel@shinybook.infradead.org>
	 <20070607235441.17dbd5cc@the-village.bc.nu>
	 <1181300467.2801.20.camel@pmac.infradead.org>
	 <20070608124853.5fdfaee2@the-village.bc.nu>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:48:27 +0100
Message-Id: <1181303307.2801.36.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 12:48 +0100, Alan Cox wrote:
> > It works fine. The only problem is that if I set a _standard_ baud rate
> > with BOTHER and then read it back with something that doesn't grok
> > BOTHER, I get it back just as I set it.
> 
> That seemed to me to be the right thing to do.
> 
> > It might be better if it was returning B38400, rather than BOTHER.
> > Should we be using tty_termios_encode_baud_rate() for TCGETS()?
> 
> You can't really do that as you get weird behaviour then when people do
> 
> 	tcgetattr
> 		|= BOTHER;
> 		speed = 19200;
> 	tcsetattr
> 
> later in the same app
> 
> 	tcgetattr
> 		speed = 38400
> 	tcsetattr
> 
> knowing that they set BOTHER already.

Hm, true.

> I guess you could add both ioctl sets anyway but the plan longer term is
> for glibc tcsetattr/getattr to do the right thing with the new ioctls in
> all cases, as the glibc interface already provides speed fields.

Even with glibc helping, I'm not sure I see how to do the right thing
for both the 'old' stty and the case you describe. We'll just have to
update stty _if_ we set arbitrary baud rates and want it to display
them.

-- 
dwmw2

