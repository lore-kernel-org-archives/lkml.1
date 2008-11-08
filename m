Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbYKHAvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbYKHAvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYKHAvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:51:41 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:44839 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYKHAvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:51:38 -0500
Date: Sat, 8 Nov 2008 01:51:25 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20081108005125.GA24783@adopmeer.homeip.net>
References: <49142351.9080805@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49142351.9080805@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Henrik,

On Fri, Nov 07, 2008 at 12:15:29PM +0100, Henrik Rydberg wrote:
> In order to utilize the full power of the new multi-touch devices, a way
> to report detailed finger data to user space is needed. This patch adds a
> multi-touch (MT) protocol which allows drivers to report details for an
> arbitrary number of fingers.

Good. Something like this is also needed for the Elantech touchpad which can
report the coordinates of two fingers on the pad simultaneously. This allows
for the well known two finger zoom and rotate gestures.

> BTN_MT_REPORT_PACKET
> 
> The driver presses this button to indicate the start of a packet of finger
> data. The button is released after the whole packet has been reported.
> 
> BTN_MT_REPORT_FINGER
> 
> The driver presses this button to indicate the start of a new finger. The
> button is released when the finger has been reported.

Hmm, why not use a new event type to report multi-touch data? I find the use
of fake buttons here kind of ugly.

> +#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
> +#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
> +#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
> +#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
> +#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
> +#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
> +#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
> +#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
> +#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */

Does your hardware provide all this data, or do you want to do the
calculations for these numbers in a kernel driver? Isn't it much easier to
do these kind of calculations in user space where you can make liberal use
of floating point numbers?

In other words, are you not overdesigning this interface or targetting it
too much to some specific hardware you have in mind? It doesn't seem to fit
the Elantech touchpad too well, for example.


Arjan

