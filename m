Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYG1SvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYG1SvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYG1SvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:51:06 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14031 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753620AbYG1SvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:51:05 -0400
Date: Mon, 28 Jul 2008 22:51:03 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
Message-ID: <20080728185103.GA25343@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-2-git-send-email-tpiepho@freescale.com> <20080727022116.GN12191@secretlab.ca> <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp> <20080728170914.GA21265@secretlab.ca> <20080728180204.GA13190@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807281120150.26456@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807281120150.26456@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:26:28AM -0700, Trent Piepho wrote:
> On Mon, 28 Jul 2008, Anton Vorontsov wrote:
> > On Mon, Jul 28, 2008 at 11:09:14AM -0600, Grant Likely wrote:
> > [...]
> >>>>> +- function :  (optional) This parameter, if present, is a string
> >>>>> +  defining the function of the LED.  It can be used to put the LED
> >>>>> +  under software control, e.g. Linux LED triggers like "heartbeat",
> >>>>> +  "ide-disk", and "timer".  Or it could be used to attach a hardware
> >>>>> +  signal to the LED, e.g. a SoC that can configured to put a SATA
> >>>>> +  activity signal on a GPIO line.
> >>>>
> >>>> This makes me nervous.  It exposes Linux internal implementation details
> >>>> into the device tree data.  If you want to have a property that
> >>>> describes the LED usage, then the possible values and meanings should be
> >>>> documented here.
> >>>
> >>> Should it be a linux specific property then?  I could list all the current
> >>> linux triggers, but enumerating every possible function someone might want
> >>> to assign to an LED seems hopeless.
> >>
> >> I'd rather see the device tree provide 'hints' toward the expected usage
> >> and if a platform needs something specific, then the platform specific
> >> code should setup the trigger.
> >>
> > Maybe we can encode leds into devices themselves, via phandles?
> 
> How will this work for anything besides ide activity?  For example, flashing,
> heartbeat, default on, overheat, fan failed, kernel panic, etc.

Everything is possible, but will look weird. For example,

Default on (power led) could be encoded in the root node.
fan and overheat in a PM controller's node.
Kernel panic in the chosen node.

> > And then the OF GPIO LEDs driver could do something like:
> >
> > char *ide_disk_trigger_compatibles[] = {
> > 	"fsl,sata",
> > 	"ide-generic",
> > 	...
> > };
> 
> Everytime someone added a new ide driver, this table would have to be updated.

Yes. device_type would be helpful here. :-)


Well, otherwise, we could provide a trigger map in the chosen node:

chosen {
	/* leds map: default-on, ide-disk, nand-disk, panic */
	linux,leds = <&green_led &red_led 0 0>;
};

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
