Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0BXCt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:49:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:44025 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0BXCtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:49:24 -0500
Subject: Re: [PATCH] windfarm: init sysfs attributes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
In-Reply-To: <1266680582.17363.7.camel@jlt3.sipsolutions.net>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
	 <1266678496.32309.1.camel@jlt3.sipsolutions.net>
	 <20100220152010.GI3000@hack>
	 <1266679687.17363.1.camel@jlt3.sipsolutions.net>
	 <20100220154049.GM3000@hack>
	 <1266680582.17363.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 13:49:13 +1100
Message-ID: <1266979753.23523.1670.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 16:43 +0100, Johannes Berg wrote:
> This is required for lockdep.

Please CC linuxppc-dev@ozlabs.org or it doesn't get caught by patchwork.

I'll fwd that one myself.

Cheers,
Ben.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/macintosh/windfarm_core.c         |    1 +
>  drivers/macintosh/windfarm_smu_controls.c |    1 +
> 
> --- wireless-testing.orig/drivers/macintosh/windfarm_smu_controls.c	2010-02-20 16:05:55.738721565 +0100
> +++ wireless-testing/drivers/macintosh/windfarm_smu_controls.c	2010-02-20 16:07:51.996717974 +0100
> @@ -173,6 +173,7 @@ static struct smu_fan_control *smu_fan_c
>  
>  	fct->fan_type = pwm_fan;
>  	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
> +	sysfs_attr_init(&fct->ctrl.attr.attr);
>  
>  	/* We use the name & location here the same way we do for SMU sensors,
>  	 * see the comment in windfarm_smu_sensors.c. The locations are a bit
> --- wireless-testing.orig/drivers/macintosh/windfarm_core.c	2010-02-20 16:15:14.701580166 +0100
> +++ wireless-testing/drivers/macintosh/windfarm_core.c	2010-02-20 16:15:38.416369684 +0100
> @@ -321,6 +321,7 @@ int wf_register_sensor(struct wf_sensor 
>  	kref_init(&new_sr->ref);
>  	list_add(&new_sr->link, &wf_sensors);
>  
> +	sysfs_attr_init(&new_sr->attr.attr);
>  	new_sr->attr.attr.name = new_sr->name;
>  	new_sr->attr.attr.mode = 0444;
>  	new_sr->attr.show = wf_show_sensor;
> 


