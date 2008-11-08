Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYKHKn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYKHKn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 05:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYKHKnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 05:43:49 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:38655 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbYKHKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:43:48 -0500
Message-ID: <49156D54.8060109@euromail.se>
Date: Sat, 08 Nov 2008 11:43:32 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Arjan Opmeer <arjan@opmeer.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se> <20081108005125.GA24783@adopmeer.homeip.net>
In-Reply-To: <20081108005125.GA24783@adopmeer.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KylI6-0007bX-4l.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KylI6-0007bX-4l 9ee935cda878519e8c8675586815eeb9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[..]

>> BTN_MT_REPORT_PACKET
[..]
>> BTN_MT_REPORT_FINGER
> 
> Hmm, why not use a new event type to report multi-touch data? I find the use
> of fake buttons here kind of ugly.

Good point, I will revise.

>> +#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
>> +#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
>> +#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
>> +#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
>> +#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
>> +#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
>> +#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
>> +#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
>> +#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
> 
> Does your hardware provide all this data, or do you want to do the
> calculations for these numbers in a kernel driver?

These are all numbers directly from the bcm5974 USB interface. There is
no computation involved.

> Isn't it much easier to
> do these kind of calculations in user space where you can make liberal use
> of floating point numbers?

For chips that cannot produce the above events, one simply reports less data.
If orientation data cannot be obtained, leave out TOUCH_MINOR, WIDTH_MINOR
and ORIENTATION. If finger width cannot be obtained, leave out WIDTH. The
minimum set of data is TOUCH, POSITION_X and POSITION_Y. If touch pressure
information is not given in trackpad dimension units, use a specific range.
I believe all current drivers are able to produce this data.

> In other words, are you not overdesigning this interface or targetting it
> too much to some specific hardware you have in mind?

It is designed to bring advanced gestures to the linux desktop. It can be
implemented on different levels depending on hardware capabilities.

