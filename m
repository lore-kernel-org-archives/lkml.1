Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbZJGRB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbZJGRB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbZJGRBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:01:55 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:11225 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbZJGRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:01:53 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4ACCC957.3060802@tremplin-utc.net>
Date: Wed, 07 Oct 2009 19:01:11 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/2] LIS3LV02D I2C driver
References: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com> <4ACCC273.1030308@gmail.com>
In-Reply-To: <4ACCC273.1030308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-10-09 18:31, Jonathan Cameron schreef:
> Just a quick heads up wrt overlapping work.
> 
> For the i2c support Kalhan Trisal has been posting patches for i2c
> support for this
> driver to the lm-sensors list for some time and the latest version of that
> set is also pretty clean.
You mean this post, right?
http://lists.lm-sensors.org/pipermail/lm-sensors/2009-August/026505.html
"Accelerometer driver for STMicroeletronics-LIS331DL-three-axis-digital"
Thanks for the heads up, I had never heard of this driver before.

Well, it's for the LIS331DL, not the LIS3LV02DL (12 bits) or the
LIS302DL (8 bits) (both supported by lis3lv02d driver). That said,
according to the specs, it seems to be _very_ similar to the LIS302DL,
they even report the same "who_am_i" value. Just some special features
are different (free fall detection for instance).
> 
> The changes in these two patch sets should probably be reconciled before
> merging.

Yes, at least from a 5 minutes look, it seems it should be possible to
merge both drivers. Samu's i2c implementation is pretty clean as well
and IMHO it seems the Right Thing to have all the bus specific parts
(I²C, SPI, ACPI/HP) "inheriting" from a generic driver. So I think we
should try to merge everything in the lis3lv02d driver. Kalhan, would
you mind having a look at the patch from Samu, and see what is required
to get your LIS331DL working with the lis3lv02d driver? It should be
very little and avoid duplication of efforts :-)

See you,
Eric
