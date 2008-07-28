Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbYG1SuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbYG1SuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYG1St7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:49:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:8241 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYG1St6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:49:58 -0400
Date: Mon, 28 Jul 2008 12:49:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
Message-ID: <20080728184955.GB21874@secretlab.ca>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-2-git-send-email-tpiepho@freescale.com> <20080727022116.GN12191@secretlab.ca> <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp> <20080728170914.GA21265@secretlab.ca> <20080728180204.GA13190@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807281120150.26456@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807281120150.26456@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
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

It certainly doesn't work for everything; but where it does work it
makes a lot of sense because the property position provides a lot of
context.

> 
> > And then the OF GPIO LEDs driver could do something like:
> >
> > char *ide_disk_trigger_compatibles[] = {
> > 	"fsl,sata",
> > 	"ide-generic",
> > 	...
> > };
> 
> Everytime someone added a new ide driver, this table would have to be updated.

Yes, the implementation needs thought.

g.
