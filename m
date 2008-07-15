Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYGOMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYGOMif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYGOMi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:38:27 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5444 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753835AbYGOMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:38:26 -0400
Date: Tue, 15 Jul 2008 16:38:22 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Richard Purdie <rpurdie@rpsys.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080715123822.GA10893@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080714164114.GA18784@polina.dev.rtsoft.ru> <20080715131004.32646dae.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080715131004.32646dae.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Tue, Jul 15, 2008 at 01:10:04PM +1000, Stephen Rothwell wrote:
[...]
> > +	led->np = np;
> 
> You need to take a reference if you are keeping a pointer to a
> device_node, so:
> 	led->np = of_node_get(np);
> 
> > +	led->cdev.name = of_get_property(np, "label", NULL);
> > +	if (!led->cdev.name)
> > +		led->cdev.name = ofdev->dev.bus_id;
> 
> Please use dev_name() in new code:
> 		led->cdev.name = dev_name(&ofdev->dev);
> 
> > +	led->cdev.brightness_set = gpio_led_set;
> > +
> > +	ret = gpio_request(led->gpio, ofdev->dev.bus_id);
> 
> dev_name() again.
> 
> > +err_get_gpio:
> 
> 	of_node_put(led->np);
> 
> > +	kfree(led);
> > +	return ret;
> > +}
> > +
> > +static int __devexit of_gpio_leds_remove(struct of_device *ofdev)
> > +{
> > +	struct of_gpio_led *led = dev_get_drvdata(&ofdev->dev);
> > +
> > +	led_classdev_unregister(&led->cdev);
> > +	cancel_work_sync(&led->work);
> > +	gpio_free(led->gpio);
> > +	of_node_put(led->np);
> 
> This was going to be unbalanced, but is now correct.

Thank you so much for the review, corrected version follows.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
