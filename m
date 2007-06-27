Return-Path: <linux-kernel-owner+w=401wt.eu-S1762597AbXF0QNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597AbXF0QNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbXF0QNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:13:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:59147 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbXF0QNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cVwRO3n3/90INVBOqpjzXqzc7MVmwxa3bJisHz+HZUc1RtT/3cnhI90u1UHMdA18tMHmRoH2vydFqyfAkzx+rFmGEHlJo9PcfN6A2Xf8mYP1/LJwX2H4cXVrF8jkfsWf8Bhm6YZMIqZbAhNpzF5MuRHgIh0DAh0KzXQjUHDyVs0=
Message-ID: <d120d5000706270913l50389090x8dbbdd5d3e4c7314@mail.gmail.com>
Date: Wed, 27 Jun 2007 12:13:09 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] touchscreen support for collie (sharp zaurus sl-5500)
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz, patches@arm.linux.org.uk
In-Reply-To: <20070627144338.GA15584@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627144338.GA15584@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 6/27/07, Pavel Machek <pavel@ucw.cz> wrote:
>
> Add driver for collie touchscreen, partly based on ucb1x00-ts.c, but
> this one actually works.
>
>
> +config MCP_COLLIE_TS
> +       tristate "Touchscreen collie support"
> +       depends on MCP_UCB1200 && INPUT && !MCP_UCB1200_TS
> +        ---help---
> +         Driver for touchscreen on collie - sharp sl-5500.
> +

Can't ucb1x00-ts be modified to properly support collie hardware?
These drivers look almost like twin brothers.

> +       input_report_abs(idev, ABS_X, x);
> +       input_report_abs(idev, ABS_Y, y);
> +       input_report_abs(idev, ABS_PRESSURE, pressure);
> +        input_report_key(idev, BTN_TOUCH, 1);

Whitespace damage...

> +       input_sync(idev);
> +}
> +
> +static inline void ucb1x00_ts_event_release(struct ucb1x00_ts *ts)
> +{
> +       struct input_dev *idev = ts->idev;
> +
> +       input_report_abs(idev, ABS_PRESSURE, 0);
> +        input_report_key(idev, BTN_TOUCH, 0);

And here...

> +
> +static int ucb1x00_ts_open(struct input_dev *idev)
> +{
> +       struct ucb1x00_ts *ts = idev->private;

Please use input_get_drvdata();

> +/*
> + * Release touchscreen resources.  Disable IRQs.
> + */
> +static void ucb1x00_ts_close(struct input_dev *idev)
> +{
> +       struct ucb1x00_ts *ts = idev->private;

And here as well.

> +
> +       idev->private    = ts;

input_set_drvdata();

-- 
Dmitry
