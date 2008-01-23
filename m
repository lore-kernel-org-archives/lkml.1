Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbYAWENv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbYAWENv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYAWENo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:13:44 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:52760 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYAWENn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:13:43 -0500
Date: Tue, 22 Jan 2008 22:00:51 -0600
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
Message-ID: <20080123040050.GA26996@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Tue, 22 Jan 2008 22:00:53 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jan 23, 2008 at 12:06:27AM +0300, Evgeniy Polyakov wrote:
> 
> What about instead of breaking application just add new sysfs file,
> which will only return temperature instead of full rom content.
> It can be millidegrees Centigrade, another one can be millikelvins :)

If someone wrote their application to read degrees C because they have
an ds18b20, the application will break anyway if they run it with an
ds1820 sensor.  Or the opposite way around.  Yes it would be better
not to break a program, but I think having a consistent interface for
both sensors to be a better option.

> Actually it is already posible for applications to decode whatever
> precision they like from the rom content displayed, although that can be
> not very convenient.

I was first surprised then glad that the raw data was included in the
user available data.  I was wanting the full precision, so that was my
plan.

> Even more, what about possibility of changing of the base, relative to
> which temperature is displayed? By default I vote for centigrades,
> those, who live behind the oceans, can setup Fahrenheit, Kelvin or anything
> else, but please in a new file :)
> David will this work for you?

I'm biased toward Fehrenheit, against Kelvin, but I think continuing
to keep Centigrade is the correct choice here.  I don't like the idea
of selecting the base the kernel displays by a userland option, too
easy to make assumptions, give it one interface and let the
application do the conversion, C/1000.0*9/5+32 is pretty easy (for
millidegrees C that is).

I'll get the trivial patch to change the ds18b20 output in
millidegrees C to make things consistent.  I'm out of time tonight.

It does sound like a good idea to have a sysfs file that just returns
the millidegrees C in ASCII without any other text.  It would be
easier to parse.  If the conversion fails return 0 bytes.  Just an
idea, but if someone wants it they can write the patch.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
