Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZGBSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZGBSAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZGBSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:00:32 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:39727 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGBSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:00:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A4CF587.1030202@gmail.com>
Date: Thu, 02 Jul 2009 17:59:35 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
       Chris Verges <chrisv@cyberswitching.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local> 	<4A4CF07B.3090600@cam.ac.uk> <8bd0f97a0907021043l30a34e6dh581ea5e96130d7eb@mail.gmail.com>
In-Reply-To: <8bd0f97a0907021043l30a34e6dh581ea5e96130d7eb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Thu, Jul 2, 2009 at 13:38, Jonathan Cameron wrote:
>   
>> One interesting thing I just came across whilst searching lkml for
>> your post to reply to, was that Mike Frysinger submited a patch
>> adding some board support for an adx34x driver to bf548-ezkit.
>> I've not seen any sign of this anywhere else as yet (it hasn't
>> hit the input list which would be the obvious place) I've copied in
>> both people who signed off.  Michael or Mike able to give us more info?
>>     
>
> that's because we're still in the process of making sure it is stable.
>  I2C is a pita to work with.
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=43d4cabbdeb5c24f84b159c5dc369c1a60844a48
>
> the advantage here is that we have been testing our driver with actual
> hardware ...
>   
Cheat ;)

Looks like a nice driver, see what you mean about the i2c fun and games
you are having
though.
I'm particularly interested in your use of the fifo:

I've only had a quick look, but assuming I read it right, you are using
the fifo
with a watermark of 0 then spitting out 3 separate events for every
element in it.
Basically a data ready response unless you fail to read in time. Seems
like a sensible
approach with this particular chip in input type applications.

Does this work well even at the higher rates?  Seems a fair bit of
overhead but I guess
if everything is quick enough it doesn't really matter. Does this act as
a clean means
of ensuring you get a consistent set of values?

Thanks,

Jonathan

