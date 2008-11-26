Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYKZSR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYKZSR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 13:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYKZSRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 13:17:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1604 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYKZSRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 13:17:16 -0500
Date: Wed, 26 Nov 2008 18:17:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add WM8350 LED driver
Message-ID: <20081126181710.GH6234@sirena.org.uk>
References: <1227707610-20952-1-git-send-email-broonie@opensource.wolfsonmicro.com> <alpine.LNX.2.00.0811261837420.23445@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0811261837420.23445@titan.stealer.net>
X-Cookie: I smell a wumpus.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 06:39:04PM +0100, Sven Wegener wrote:

You should cut irrelevant text from your mail; it makes it much easier
to find what you're actually saying - if you've got hundreds of lines of
unbroken quoted text it's easy to page straight past small comments.

> On Wed, 26 Nov 2008, Mark Brown wrote:

> > +	isink = regulator_get(&pdev->dev, "led_isink");
> > +	if (IS_ERR(isink) || isink == NULL) {
> > +		printk(KERN_ERR "%s: cant get ISINK\n", __func__);
> > +		return PTR_ERR(isink);

> Uhm, if isink is ever NULL, which according to your check above you
> expect it to happen, this will return 0, meaning success. I'm not sure
> if this is what you want and looking at regulator_get() it should never
> be NULL.

No, it should never be NULL - this is was inherited from the out of tree
history.

> > +	for (i = 0; i < ARRAY_SIZE(isink_cur) - 1; i++)

> This loop will skip the last array member.

This is intentional, it ensures that we always end up pointing to a
value within the array.

> > +int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
> > +			struct wm8350_led_platform_data *pdata)
> > +{
> > +	struct wm8350_led *led = &wm8350->pmic.led[lednum];
> > +	struct platform_device *pdev;
> > +	int ret;
> > +
> > +	if (lednum > ARRAY_SIZE(wm8350->pmic.led) || lednum < 0) {
> > +		dev_err(wm8350->dev, "Invalid LED index %d\n", lednum);
> > +		return -ENODEV;
> > +	}

> You already used lednum as an array index above, I'm not sure if this
> can have any side effects. I think it shouldn't, as you only use it to
> get a pointer.

It's out of spec to index beyond the end of the array but shouldn't
produce any actual runtime problems unless the either the implementation
or the platform code is being silly.  I'll shuffle the code around,
though.

Fixed everything else.
