Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXIKQET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXIKQET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXIKQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:04:12 -0400
Received: from mailhub.linpro.no ([213.236.139.167]:55041 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXIKQEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:04:10 -0400
From: =?iso-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no> <46E6A737.6080805@anagramm.de>
	<ujrabrt2qkt.fsf@false.linpro.no> <46E6B617.7030106@anagramm.de>
Date: Tue, 11 Sep 2007 18:04:06 +0200
In-Reply-To: <46E6B617.7030106@anagramm.de> (Clemens Koller's message of "Tue,
	11 Sep 2007 17:36:55 +0200")
Message-ID: <ujr1wd52npl.fsf@false.linpro.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller <clemens.koller@anagramm.de> writes:
> Dag-Erling Smørgrav <des@linpro.no> writes:
> > Without knowing exacly which chip is present, there is no way for the
> > userland calibration tool to know how big a difference a calibration
> > step makes.
> I am not talking about the calibration algorithm and it's quality.

Neither am I.

> I am talking about _how_ the calibration register is addressed from
> userspace. It's a simple register, some bits at address 7 and I would
> expect to read/modify/write registers to do all the things you want
> to do. Register access in userspace doesn't put any limitation
> to applications.

It requires the application to know the hardware intimately.

Calibration of the M41T11 is implemented using the lower 6 bits of
register 7; this is not necessarily the case for other existing or
future chips.

Let's say I normalize this to [-128;127]; an application that tried to
speed up the clock would waste several hours increasing the
calibration value from 0 to 1, 2, 3 before seeing an effect after
increasing it to 4.  And how do I normalize the assymetric range of
the M41T11?

> Having only incs and decs without getting the actual value back seems
> to be an absolutely unnecessary limitation here.
> You cannot get the current value back to see if it's i.e. in saturation in
> a way that it doesn't make sense to inc/decrement it further or in bigger steps
> or reset it to zero...

The driver will return EINVAL if you try to increment or decrement the
calibration register beyond its limits.

DES
-- 
Dag-Erling Smørgrav
Senior Software Developer
Linpro AS - www.linpro.no
