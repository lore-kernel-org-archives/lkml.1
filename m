Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbYJ0JBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbYJ0JBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJ0JBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:01:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34606 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYJ0JBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:01:16 -0400
Date: Mon, 27 Oct 2008 10:01:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver
Message-ID: <20081027090115.GD30526@atrey.karlin.mff.cuni.cz>
References: <20081022154459.GA26291@elf.ucw.cz> <20081026233901.7087e74a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026233901.7087e74a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Thanks for taking the patch...

> > +/* joystick device poll interval in milliseconds */
> > +#define MDPS_POLL_INTERVAL 50
> >
> > ...
> >
> > +static int lis3lv02d_joystick_kthread(void *data)
> > +{
> > +	int x, y, z;
> > +
> > +	while (!kthread_should_stop()) {
> > +		lis3lv02d_get_xyz(adev.device->handle, &x, &y, &z);
> > +		input_report_abs(adev.idev, ABS_X, x - adev.xcalib);
> > +		input_report_abs(adev.idev, ABS_Y, y - adev.ycalib);
> > +		input_report_abs(adev.idev, ABS_Z, z - adev.zcalib);
> > +
> > +		input_sync(adev.idev);
> > +
> > +		try_to_freeze();
> > +		msleep_interruptible(MDPS_POLL_INTERVAL);
> 
> You'll have the powertop police on your tail.
> 
> Is there no alternative?

No, I do not think so. The device is noisy enough that it will
"always" generate a change -- even when sittig on the desktop
quietly. We could switch to interrupt mode but it would just give us
iterrupts at 40Hz.

For harddisk protection it _might_ be possible to do something clever
with threshold comparator on the chip, but... we are not even using
the comparator for now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
