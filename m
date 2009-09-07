Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZIGJH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZIGJH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZIGJH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:07:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39514 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752227AbZIGJH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:07:56 -0400
Date: Mon, 7 Sep 2009 10:07:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Panin <pazke@centrinvest.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
Message-ID: <20090907090757.GB21558@rakim.wolfsonmicro.main>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090907072507.GA19269@centrinvest.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907072507.GA19269@centrinvest.ru>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 11:25:07AM +0400, Andrey Panin wrote:
> On 248, 09 05, 2009 at 02:09:21PM +0100, Mark Brown wrote:

> > +	if (res == NULL) {
> > +		dev_err(&pdev->dev, "No I/O resource\n");
> > +		ret = -EINVAL;
> > +		goto err;

> Why not return -EINVAL right here ?

For consistency with the rest of the function which uses this style for
unwinding (though I see there's a cut'n'pasted return early on which
it'd be nice to clean up).

> > +err_led:
> > +	led_classdev_unregister(&drvdata->cdev);

> This line looks useless and possibly unsafe, led device was not registered.

True.

> Also this part of code can be removed if you move next line up.

I'd prefer to keep the unwinding at the end, it makes the initialisation
much easier to modify.
