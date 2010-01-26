Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660Ab0AZVpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0AZVpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532Ab0AZVpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:45:21 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:56474 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab0AZVpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:45:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19295.25195.709536.806581@stoffel.org>
Date: Tue, 26 Jan 2010 16:45:15 -0500
From: "John Stoffel" <john@stoffel.org>
To: Stanislav Brabec <utx@penguin.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to write driver that needs to call another driver?
In-Reply-To: <1264540265.2411.20.camel@utx.utx.cz>
References: <1264540265.2411.20.camel@utx.utx.cz>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stanislav> My Zaurus SL-C3200 PDA needs a driver that needs to call
Stanislav> another driver from another part of the device tree:

Stanislav> MAX1111 (4 channel A/D) is connected to several other
Stanislav> pieces of hardware (audio player remote keyboard, battery
Stanislav> voltage, battery temperature, external power voltage).

Stanislav> Battery power and charging management needs to read values
Stanislav> from MAX1111 during. Also Remote Keyboard input device
Stanislav> needs to read MAX1111.

Stanislav> But both drivers also need dedicated GPIO that are
Stanislav> allocated on Scoop chip (different part of the platform
Stanislav> device tree).

Stanislav> What is the best way to implement it?

By no means am I a driver expert or writer, but from what I recall in
the past when such questions came up is for you to write a low level
core driver, which binds to the device, and then exposes that various
interfaces you want to bind to for other devices to talk to.

This gets the ref counting right, and lets you know when something is
accessing the MAX1111, so that suspend and such happen in the correct
order.

Look through the lkml archives for previous answers.  I'm sure Greg
will have a better answer and a pointer to an example driver to look
at.

Cheers,
John
