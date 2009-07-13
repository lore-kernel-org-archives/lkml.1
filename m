Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZGMWUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZGMWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZGMWUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:20:08 -0400
Received: from ru.mvista.com ([213.79.90.228]:64568 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751932AbZGMWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:20:07 -0400
Date: Tue, 14 Jul 2009 02:20:05 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20090713222005.GA19859@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
 <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
 <20090713173455.GA9866@oksana.dev.rtsoft.ru>
 <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 09:59:54PM +0200, Joakim Tjernlund wrote:
[...]
> > > While being at it, the reason for me needing this is that the spi_mpc83xx driver
> > > was recently converted to a OF only driver so I have no way of defining my own
> > > CS function anymore. While OF is good I don't feel that OF drivers should
> > block the native
> > > method, OF should be a layer on top of the native methods.
> >
> > Um, I don't get it. You have a mux, which is a sort of GPIO controller.
> > All you need to do is to write "of-gpio-mux" driver, that will get all
> > the needed gpios from the underlaying GPIO controller.
> 
> Well, I already have a mux controller that is using the native spi methods. I
> don't want to write a new one, far more complicated than what I got now.
> While the OF system is very powerful and flexible I still think that
> one should be able to use native SPI methods too. Why can they not
> co-exist?

I strongly believe that they can. You just need to post patches
so that we could see them, and maybe discuss how to do things
more generic. But if making things generic will be too hard (see
below), I don't think anybody will object applying a non-generic
solution (even permitting "legacy" bindings in the spi_8xxx driver).

But any users of the legacy bindings should be in-tree.

> > In the device tree it'll look like this:
> 
> I must admit that I just started to look at the GPIO subsystem, but
> I do wonder if mpc83xx_spi_cs_control() can do this muxing
> without any change.
> 
> Very good example BTW.

Well, there is one caveat: the "GPIOs" aren't independent,
so thinking about it more, I believe we should now discuss
"chip-select framework", not gpio controllers (it could be
that using gpio controllers for this purpose wasn't that
good idea).

http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg34738.html
^^^ I'm dreaming about this framework. I.e. true addressing
    for chip-selects. :-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
