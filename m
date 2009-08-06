Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZHFAvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZHFAvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZHFAvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:51:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZHFAvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:51:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 4/5] input: gpio-keys: switch to new dev_pm_ops
Date: Thu, 6 Aug 2009 02:51:55 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, pHilipp Zabel <philipp.zabel@gmail.com>,
       Phil Blundell <pb@handhelds.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de> <74d0deb30908051315l43b00731yb79f7937707068ec@mail.gmail.com> <20090805223342.GG19257@buzzloop.caiaq.de>
In-Reply-To: <20090805223342.GG19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908060251.55157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Daniel Mack wrote:
> On Wed, Aug 05, 2009 at 10:15:52PM +0200, pHilipp Zabel wrote:
> > On Wed, Aug 5, 2009 at 8:29 PM, Daniel Mack<daniel@caiaq.de> wrote:
> > > -static int gpio_keys_resume(struct platform_device *pdev)
> > > +static int gpio_keys_resume(struct device *dev)
> > >  {
> > > -       struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
> > > +       struct gpio_keys_platform_data *pdata = dev->platform_data;
> > >        int i;
> > >
> > > -       if (device_may_wakeup(&pdev->dev)) {
> > > +       if (device_may_wakeup(dev)) {
> > >                for (i = 0; i < pdata->nbuttons; i++) {
> > >                        struct gpio_keys_button *button = &pdata->buttons[i];
> > >                        if (button->wakeup) {
> > > @@ -251,19 +251,27 @@ static int gpio_keys_resume(struct platform_device *pdev)
> > >
> > >        return 0;
> > >  }
> > > +
> > > +static struct dev_pm_ops gpio_keys_pm_ops = {
> > > +       .suspend        = gpio_keys_suspend,
> > > +       .freeze         = gpio_keys_suspend,
> > > +       .resume         = gpio_keys_resume,
> > > +       .thaw           = gpio_keys_resume,
> > 
> > I'm not sure I understand hibernation correctly, but isn't
> > .freeze/.thaw about saving state and halting/resuming the device
> > operation only?

It is.

> > It seems to me that enabling system wakeup functionality should go
> > into .poweroff. (See <linux/pm.h>)

That's correct.

And .restore() plays the role of ".resume() from hibernation".

> Frankly, I'm not sure either. But luckily, the linux-pm list is copied
> so someone can elborate on this :)

HTH

Best,
Rafael
