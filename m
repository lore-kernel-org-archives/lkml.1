Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZAMWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZAMWdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZAMWdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:33:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60608 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZAMWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:33:09 -0500
Date: Tue, 13 Jan 2009 23:33:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net
Subject: Re: hp_accel: do not call ACPI from invalid context
Message-ID: <20090113223300.GB7770@elf.ucw.cz>
References: <20090112103155.GA6652@elf.ucw.cz> <20090113141116.6faeada9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113141116.6faeada9.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 14:11:16, Andrew Morton wrote:
> On Mon, 12 Jan 2009 11:31:55 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > 
> > LED on HP notebooks is connected through ACPI. That unfortunately
> > means that it needs to be delayed by using schedule_work() to avoid
> > calling ACPI interpretter in invalid context. This patch fixes that.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>


> > -static void hpled_set(struct led_classdev *led_cdev,
> > -			       enum led_brightness value)
> > -{
> > -	hpled_acpi_write(adev.device->handle, !!value);
> > -}
> > -
> > -static struct led_classdev hpled_led = {
> > -	.name			= "hp:red:hddprotection",
> > -	.default_trigger	= "heartbeat",
> 
> Current mainline+lis3lv02d-merge-with-leds-hp-disk.patch has "none"
> here, so the patch didn't apply.

Oops, sorry about that. I was hand-editing patches a bit too much :-(.

> > -	.brightness_set		= hpled_set,
> > +static struct delayed_led_classdev hpled_led = {
> > +	.led_classdev = {
> > +		.name			= "hp::hddprotect",
> > +		.default_trigger	= "none",
> 
> But I assume we wanted "none" here anyway, so that's what I'll do.

Thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
