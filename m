Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYG1SGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYG1SGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYG1SGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:06:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:41901 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYG1SGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:06:38 -0400
Date: Mon, 28 Jul 2008 12:06:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
Message-ID: <20080728180631.GE21534@secretlab.ca>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-2-git-send-email-tpiepho@freescale.com> <20080727022116.GN12191@secretlab.ca> <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp> <20080728170914.GA21265@secretlab.ca> <20080728180204.GA13190@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728180204.GA13190@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:02:04PM +0400, Anton Vorontsov wrote:
> On Mon, Jul 28, 2008 at 11:09:14AM -0600, Grant Likely wrote:
> > I'd rather see the device tree provide 'hints' toward the expected usage
> > and if a platform needs something specific, then the platform specific
> > code should setup the trigger.
> > 
> > Regardless, any hints provided by the binding must be documented.  In
> > most cases the gpio-leds driver should be able to figure out which trigger
> > to bind without platform code intervention.
> 
> Maybe we can encode leds into devices themselves, via phandles?
> 
> E.g.
> 
> sata@101 {
> 	compatible = "fsl,sata";
> 	leds = <&red_led>;
> };

I like that idea!  That neatly solves the problem for many use cases.

> And then the OF GPIO LEDs driver could do something like:
> 
> char *ide_disk_trigger_compatibles[] = {
> 	"fsl,sata",
> 	"ide-generic",
> 	...
> };
> 
> for_each_node_with_leds_property(node, led_phandle) {
> 	if (if_ide_disk_compatible(node)) {
> 		struct gpio_led *led = phandle_to_led(led_phandle);
> 
> 		led->default_trigger = "ide-disk";
> 	}
> }

I'm not sure what would be best for implementation details, but
implementation details can easily be changed.

> 
> -- 
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
