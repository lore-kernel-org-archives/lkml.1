Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZGBSMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZGBSMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGBSMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:12:24 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:48019 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZGBSMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:12:23 -0400
X-IronPort-AV: E=Sophos;i="4.42,336,1243828800"; 
   d="scan'208";a="1021521"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Date: Thu, 2 Jul 2009 19:12:26 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0C2497DC@limkexm3.ad.analog.com>
In-Reply-To: <4A4CF587.1030202@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Thread-Index: Acn7PwVYziD9+qw8TACFyem06RQ4sAAAOHYQ
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local> 	<4A4CF07B.3090600@cam.ac.uk> <8bd0f97a0907021043l30a34e6dh581ea5e96130d7eb@mail.gmail.com> <4A4CF587.1030202@gmail.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Jonathan Cameron" <Jonathan.Cameron@gmail.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>
CC: "Jonathan Cameron" <jic23@cam.ac.uk>,
       "Chris Verges" <chrisv@cyberswitching.com>,
       <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 Jul 2009 18:12:26.0088 (UTC) FILETIME=[A7590E80:01C9FB40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: J.I. Cameron [mailto:jic23@hermes.cam.ac.uk] On Behalf Of
Jonathan Cameron
>Mike Frysinger wrote:
>> On Thu, Jul 2, 2009 at 13:38, Jonathan Cameron wrote:
>>
>>> One interesting thing I just came across whilst searching lkml for
>>> your post to reply to, was that Mike Frysinger submited a patch
>>> adding some board support for an adx34x driver to bf548-ezkit.
>>> I've not seen any sign of this anywhere else as yet (it hasn't
>>> hit the input list which would be the obvious place) I've copied in
>>> both people who signed off.  Michael or Mike able to give us more
info?
>>>
>>
>> that's because we're still in the process of making sure it is
stable.
>>  I2C is a pita to work with.
>>
>http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitd
iff;h=43d4cabbdeb5c24f84b159c5
>dc369c1a60844a48
>>
>> the advantage here is that we have been testing our driver with
actual
>> hardware ...
>>
>Cheat ;)
>
>Looks like a nice driver, see what you mean about the i2c fun and games
>you are having
>though.
>I'm particularly interested in your use of the fifo:
>
>I've only had a quick look, but assuming I read it right, you are using
>the fifo
>with a watermark of 0 then spitting out 3 separate events for every
>element in it.
>Basically a data ready response unless you fail to read in time. Seems
>like a sensible
>approach with this particular chip in input type applications.

We fully use the FIFO - the link Mike sent around was the initial
checkin.
After that I fixes some bugs and added functionality.
BTW I also implemented the Watermark feature.

http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:adxl34
x


>
>Does this work well even at the higher rates?  Seems a fair bit of
>overhead but I guess
>if everything is quick enough it doesn't really matter. Does this act
as
>a clean means
>of ensuring you get a consistent set of values?

It works pretty well - the driver supports both SPI and I2C interface.
With SPI it's no problem to even use the 3200HZ sample rate.

See the comments in our documentation page.
400kHz I2C clock is the limiting factor when using the I2C interface.


Best regards,
Michael

>
>Thanks,
>
>Jonathan

