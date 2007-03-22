Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXCVPhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXCVPhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbXCVPhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:37:36 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:38254 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228AbXCVPhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:37:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoUAHs/AkZKhRO4UGdsb2JhbACHL4dsAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Nicolas Boichat <nicolas@boichat.ch>
Subject: Re: [PATCH] Apple SMC driver (hardware monitoring and control)
Date: Thu, 22 Mar 2007 11:37:34 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, rlove@rlove.org, linux-kernel@hansmi.ch
References: <45F7C083.7090504@boichat.ch> <45FE1D44.8000805@boichat.ch>
In-Reply-To: <45FE1D44.8000805@boichat.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703221137.35906.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Monday 19 March 2007 01:19, Nicolas Boichat wrote:
> +       /* initialize the input class */
> +       applesmc_idev->name = "applesmc";

You may want to set applesmc_idev->id.bus = BUS_HOST;

> +       applesmc_idev->cdev.dev = &pdev->dev;
> +       applesmc_idev->evbit[0] = BIT(EV_ABS);
> +       input_set_abs_params(applesmc_idev, ABS_X,
> +                       -256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
> +       input_set_abs_params(applesmc_idev, ABS_Y,
> +                       -256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
> +
> +       input_register_device(applesmc_idev);

Please add error hanling here.

> +
> +       /* start up our timer for the input device */
> +       init_timer(&applesmc_timer);
> +       applesmc_timer.function = applesmc_mousedev_poll;
> +       applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
> +       add_timer(&applesmc_timer);
> 

Please consider implemention open and close methods for the input
device and start/stop timer from there - there is no point of checking
hardware state if noone is listening to events. 

-- 
Dmitry
