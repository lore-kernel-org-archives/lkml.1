Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZESLpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZESLpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZESLpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:45:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZESLpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:45:15 -0400
Date: Tue, 19 May 2009 07:45:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Nick Kossifidis <mickflemm@gmail.com>, jirislaby@gmail.com,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: prevent infinite loop
In-Reply-To: <43e72e890905182339u68c4d4f5v3a2f25e9e3547e60@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905190743070.1767@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com>  <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com>  <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com> <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com>
 <43e72e890905182339u68c4d4f5v3a2f25e9e3547e60@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 18 May 2009, Luis R. Rodriguez wrote:

> On Mon, May 18, 2009 at 11:32 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > 2009/5/19 Steven Rostedt <rostedt@goodmis.org>:
> >>
> >> On Tue, 19 May 2009, Nick Kossifidis wrote:
> >>>
> >>> This is already fixed on wireless-testing ;-)
> >>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD
> >>
> >> Thanks, but this does only half. Although I did not hit this in my laptop,
> >> it can be an issue. If step[0] == step[1] you have the same problem.
> >>
> >
> > Having the same power value for 2 different steps is something we can
> > expect (although docs say that we expect the line to be monotonically
> > increasing but anyway), having the same step twice is way out of spec,
> > there is no way we can have the same step twice on EEPROM, only if we
> > have a corrupted EEPROM (we need to add some sanity checks indeed here
> > -> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/eeprom.c;h=c56b494d417acd40d445d922f2861b53cc2315df;hb=HEAD#l910
> > to handle such a case but first we need to have a "default" eeprom
> > dataset to fallback when we get such errors).
> 
> Don't bother with busted EEPROMs, if its busted its busted. Chances
> are the complexity we'd need to add to deal with such devices is
> simply not worth it.

My concern is that a busted EEPROM should not lock up the kernel, when we 
can avoid it. Put in a nasty WARN_ON if the steps are equal, and exit the 
routine. But don't let it go into an infinite loop and have the user 
wondering why their system just locked up.

-- Steve

