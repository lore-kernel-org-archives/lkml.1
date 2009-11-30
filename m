Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZK3PSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZK3PSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZK3PSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:18:38 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:14405 "EHLO
	mx3.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824AbZK3PSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:18:37 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B13E252.7040800@tremplin-utc.net>
Date: Mon, 30 Nov 2009 16:18:42 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3 5/5] LIS3: Update documentation to match latest changes
References: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-3-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-5-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-6-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1258622842-23129-6-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-11-09 10:27, Samu Onkalo schreef:
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  Documentation/hwmon/lis3lv02d |   31 ++++++++++++++++++++++++-------
>  1 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
> index 21f0902..cd354e3 100644
> --- a/Documentation/hwmon/lis3lv02d
> +++ b/Documentation/hwmon/lis3lv02d
> @@ -20,18 +20,35 @@ sporting the feature officially called "HP Mobile Data Protection System 3D" or
>  models (full list can be found in drivers/hwmon/hp_accel.c) will have their
>  axis automatically oriented on standard way (eg: you can directly play
>  neverball). The accelerometer data is readable via
> -/sys/devices/platform/lis3lv02d.
> +/sys/devices/platform/lis3lv02d. Reported values are scaled
> +to mg values (1/1000th of earth gravity).
>  
>  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
>  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> -calibrate - read: values (x, y, z) that are used as the base for input
> -		  class device operation.
> -            write: forces the base to be recalibrated with the current
> -		   position.
> -rate - reports the sampling rate of the accelerometer device in HZ
> +rate - read reports the sampling rate of the accelerometer device in HZ.
> +	write changes sampling rate of the accelerometer device.
> +	Only values which are supported by HW are accepted.
> +selftest - performs selftest for the chip as specified by chip manufacturer.
>  
>  This driver also provides an absolute input class device, allowing
> -the laptop to act as a pinball machine-esque joystick.
> +the laptop to act as a pinball machine-esque joystick. Joystick device can be
> +calibrated. Joystick device can be in two different modes.
> +By default output values are scaled between -32768 .. 32767. In joystick raw
> +mode, joystick and sysfs position entry have the same scale. There can be
> +small difference due to input system fuzziness feature.
> +Events are also available as input event device.
> +
> +Selftest is meant only for hardware diagnostic purposes. It is not meant to be
> +used during normal operations. Position data is not corrupted during selftest
> +but interrupt behaviour is not quaranteed to work reliably. In test mode, the
> +sensing element is internally moved little bit. Selftest measures difference
> +between normal mode and test mode. Chip specifications tell the acceptance
> +limit for each type of the chip. Limits are provided via platform data
> +to allow adjustment of the limits without a change to the actual driver.
> +Seltest returns either "OK x y z" or "FAIL x y z" where x, y and z are
> +measured difference between modes. Axes are not remapped in selftest mode.
> +Measurement values are provided to help HW diagnostic applications to make
> +final decision.
>  
>  On HP laptops, if the led infrastructure is activated, support for a led
>  indicating disk protection will be provided as /sys/class/leds/hp::hddprotect.

