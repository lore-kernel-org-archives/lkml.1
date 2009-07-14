Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZGNWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZGNWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZGNWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:18:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42958 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZGNWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:18:20 -0400
Date: Wed, 15 Jul 2009 00:16:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090714221638.GA6512@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz> <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com> <20090710103243.GB7789@elf.ucw.cz> <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com> <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz> <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com> <20090714094629.GB2076@elf.ucw.cz> <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> >        if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> >> >                printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
> >> > @@ -269,6 +354,9 @@ static int synaptics_ts_probe(
> >> >        pdata = client->dev.platform_data;
> >> >        if (pdata)
> >> >                ts->power = pdata->power;
> >> > +       else
> >> > +               pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> >> > +
> >>
> >> Where do you free this?
> >
> > Well, nowhere; but it should not actually matter. ... btw can this
> > path (!pdata) actually trigger? The driver will not be working,
> > anyway, in that case..
> 
> The driver should work fine without the pdata. The pdata is used to
> align the touchscreen data with the screen behind it.

Ok...

> >> This driver only supports a subset of Synaptics' devices so a more
> >> generic driver will eventually be needed. The patch below adds support
> >> for a more recent but similar panel.
> >
> > Ok, that should be simple enough to apply, but lets do improvements
> > when we cleaned the code enough for the mainline...?
> 
> We need this change now. Your cleanup will cause conflicts for anyone
> using our driver, so it would be better if it includes all our fixes.

Well, I don't expect you to use the cleaned-up driver as-is: I had to
remove the wakelocks functionality as infrastructure is not in
mainline. (Plus, I do not have hardware to test your latest version).

Applying small patch on top of cleaned up driver should be better than
carrying whole driver itself, right?

[Alternatively... I can try to incorporate your change, but I'd need
your testing at that point.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
