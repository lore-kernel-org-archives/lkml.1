Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0BTPRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:17:30 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:51109 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0BTPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RRu5NpZlNbRgjh5FcfEjLs6WcoG7VMHnUbvp70sSgD7FtqYK3RbChR/KPEOOpoUdqD
         oTnyyfM+g2DarHPmRezNTjjhBFwBnvCfYjYDS78TWi0FiolIX9oJvMMsaOhb0YuJoM16
         4NS4mthPxRessSdYa1XZnPWCX2PDKLc9KkSps=
Date: Sat, 20 Feb 2010 23:20:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: sysfs lockdep complaint
Message-ID: <20100220152010.GI3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net> <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com> <1266664814.11514.5.camel@jlt3.sipsolutions.net> <20100220135122.GB3000@hack> <1266674493.18465.9.camel@jlt3.sipsolutions.net> <20100220150327.GG3000@hack> <1266678496.32309.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266678496.32309.1.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 04:08:16PM +0100, Johannes Berg wrote:
>On Sat, 2010-02-20 at 23:03 +0800, Américo Wang wrote:
>
>>  	fct->fan_type = pwm_fan;
>>  	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
>> +	sysfs_attr_init(&fct->ctrl.attr);
>
>ah, needs to be "ctrl.attr.attr".
>

Ouch, right... Updated.

Thank you!


---
diff --git a/drivers/macintosh/windfarm_smu_controls.c b/drivers/macintosh/windfarm_smu_controls.c
index 6c68b9e..5f4e5a0 100644
--- a/drivers/macintosh/windfarm_smu_controls.c
+++ b/drivers/macintosh/windfarm_smu_controls.c
@@ -173,6 +173,7 @@ static struct smu_fan_control *smu_fan_create(struct device_node *node,
 
 	fct->fan_type = pwm_fan;
 	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
+	sysfs_attr_init(&fct->ctrl.attr.attr);
 
 	/* We use the name & location here the same way we do for SMU sensors,
 	 * see the comment in windfarm_smu_sensors.c. The locations are a bit
