Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXFLFHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXFLFHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXFLFHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:07:16 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:57763 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbXFLFHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:07:15 -0400
From: Dmitry Torokhov <dtor@insightbb.com>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Date: Tue, 12 Jun 2007 01:07:13 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070609084800.GR6362@aehallh.com>
In-Reply-To: <20070609084800.GR6362@aehallh.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706120107.13655.dtor@insightbb.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zephaniah,

On Saturday 09 June 2007 04:48, Zephaniah E. Hull wrote:
> EVIOCGRAB is nice and very useful, however over time I've gotten
> multiple requests to make it possible for applications to get events
> straight from the event device while xf86-input-evdev is getting events
> from the same device.
> 
> Here is the least invasive patch I could think of, it changes the
> behavior of EVIOCGRAB in some cases, specificly behavior is identical if
> the argument is 0 or 1, however if the argument is true and != 1, then
> it does a 'non exclusive grab', a better name might be handy.
> 
> What this does is allow the events to go to everything that's using
> evdev to get events, but grabs it from anything else.  About as close to
> what people want as I can get, and fairly non-invasive.

Unfortunately this also robs non-legacy input handlers (such as
rfkill-input) of input events. Does xf86-input-evdev really needs to
grab devices exclusively? I guess we can't abandon the standard
keyboard driver until X supports hotplugging. How close is it to
support devices coming and going?
 
If we can't remain as is until X hotplug is ready then I'd rather had
a separate ioctl that disables legacy input handlers (keyboard, mousedev)
for a given input device.

-- 
Dmitry
