Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYKORb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYKORb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYKORbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:31:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33814 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751770AbYKORbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:31:21 -0500
Date: Sat, 15 Nov 2008 18:31:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Fix locking for WM8350
Message-ID: <20081115173110.GD1523@ucw.cz>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-13 14:57:49, Mark Brown wrote:
> LED API functions aren't allowed to sleep so we can't take a lock when
> setting the brightness of the LED.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Sorry, I managed to drop this fix when moving the driver over to
> mainline for submission.  I'll roll it into the original patch in any
> future submissions.
> 
>  drivers/leds/leds-wm8350.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
> index f3e5af3..283625c 100644
> --- a/drivers/leds/leds-wm8350.c
> +++ b/drivers/leds/leds-wm8350.c
> @@ -170,10 +170,7 @@ static void wm8350_led_set(struct led_classdev *led_cdev,
>  {
>  	struct wm8350_led *led = to_wm8350_led(led_cdev);
>  
> -	mutex_lock(&led->mutex);
>  	led->value = value;
> -	mutex_unlock(&led->mutex);
> -
>  	schedule_work(&led->work);
>  }

Unfortunately, now you write to value w/o locking -> races
possible. Maybe you need to make value atomic_t?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
