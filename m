Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZHEWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZHEWdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZHEWdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:33:50 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34057 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZHEWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:33:45 -0400
Date: Thu, 6 Aug 2009 00:33:42 +0200
From: Daniel Mack <daniel@caiaq.de>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Phil Blundell <pb@handhelds.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/5] input: gpio-keys: switch to new dev_pm_ops
Message-ID: <20090805223342.GG19257@buzzloop.caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de> <1249496971-9019-2-git-send-email-daniel@caiaq.de> <1249496971-9019-3-git-send-email-daniel@caiaq.de> <1249496971-9019-4-git-send-email-daniel@caiaq.de> <74d0deb30908051315l43b00731yb79f7937707068ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74d0deb30908051315l43b00731yb79f7937707068ec@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:15:52PM +0200, pHilipp Zabel wrote:
> On Wed, Aug 5, 2009 at 8:29 PM, Daniel Mack<daniel@caiaq.de> wrote:
> > -static int gpio_keys_resume(struct platform_device *pdev)
> > +static int gpio_keys_resume(struct device *dev)
> >  {
> > -       struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
> > +       struct gpio_keys_platform_data *pdata = dev->platform_data;
> >        int i;
> >
> > -       if (device_may_wakeup(&pdev->dev)) {
> > +       if (device_may_wakeup(dev)) {
> >                for (i = 0; i < pdata->nbuttons; i++) {
> >                        struct gpio_keys_button *button = &pdata->buttons[i];
> >                        if (button->wakeup) {
> > @@ -251,19 +251,27 @@ static int gpio_keys_resume(struct platform_device *pdev)
> >
> >        return 0;
> >  }
> > +
> > +static struct dev_pm_ops gpio_keys_pm_ops = {
> > +       .suspend        = gpio_keys_suspend,
> > +       .freeze         = gpio_keys_suspend,
> > +       .resume         = gpio_keys_resume,
> > +       .thaw           = gpio_keys_resume,
> 
> I'm not sure I understand hibernation correctly, but isn't
> .freeze/.thaw about saving state and halting/resuming the device
> operation only?
> It seems to me that enabling system wakeup functionality should go
> into .poweroff. (See <linux/pm.h>)

Frankly, I'm not sure either. But luckily, the linux-pm list is copied
so someone can elborate on this :)

Daniel

