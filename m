Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIOJjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIOJjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZIOJje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:39:34 -0400
Received: from smtprelay08.ispgateway.de ([80.67.31.42]:48613 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZIOJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:39:25 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 05:39:24 EDT
Message-ID: <4AAF5E6F.4030307@ladisch.de>
Date: Tue, 15 Sep 2009 11:29:19 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Taht <d@teklibre.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Frontier USB Drivers (Was: Staging tree status for the .32 kernel
 merge)
References: <20090903041429.GA29875@kroah.com> <8763bodk9f.fsf@mahal.sjds.teklibre.org> <20090914173544.GC26582@kroah.com>
In-Reply-To: <20090914173544.GC26582@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Taht wrote:
> 	- fix userspace interface to be sane
> 
> This is the biggest open question I have. Right now the drivers just
> handle the interrupts, and queue up the data in a ringbuffer, sending the
> events in the exact same format as received from the device, and vice versa.
> 
> Coming up with an abstract means to handle a very specialized device - a
> control surface that simultaneously is a LCD screen, a bunch of LEDS, a
> scroll wheel, and 20+ buttons that can be pressed in various
> combinations, would kind of involve reinventing a char I/O based X11,
> and I don't really feel that much or any of that needs to happen in
> kernel space.
> 
> (the alphatrack is worse, it has a slider with feedback and buttons that
> have touch sensitivity, and a special key that remaps the sliders and
> buttons to another keymap entirely)
> 
> There are a lot of "surfaces" out there in the music world, with all
> kinds of combinations of buttons and knobs and gee-gaws, etc,

... and practically all of them send/receive MIDI messages, which ties
in with the fact that most applications you would want to control with
this allow to be controlled by MIDI.

The Frontier Windows drivers also have a MIDI mode, so I'd strongly
suggest that you implement that.

> Far better, I thought, to just handle the RT critical portions of the
> code in the kernel and hand off the rest of the chaos to userspace.

The ALSA framework already handles buffering and routing of MIDI events,
so you'd just have to map between the device's bits and sequencer events.


Best regards,
Clemens
