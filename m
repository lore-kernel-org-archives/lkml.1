Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZIVTP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZIVTP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZIVTP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:15:56 -0400
Received: from mx0.towertech.it ([213.215.222.73]:42652 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751387AbZIVTPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:15:55 -0400
Date: Tue, 22 Sep 2009 21:15:46 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: herton@mandriva.com.br, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [rtc-linux] Re: rtc_cmos oops in cmos_rtc_ioctl
Message-ID: <20090922211546.44c0cf56@i1501.lan.towertech.it>
In-Reply-To: <200909221515.26777.herton@mandriva.com.br>
References: <200909211553.38409.herton@mandriva.com.br>
	<20090922124041.62abee25@i1501.lan.towertech.it>
	<200909221515.26777.herton@mandriva.com.br>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 15:15:26 -0300
Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> 
> Something like this?:
> 
> From a94365843ab40a1904c4bc244af4e551f2f2aca9 Mon Sep 17 00:00:00 2001
> From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Date: Tue, 22 Sep 2009 13:46:00 -0300
> Subject: [PATCH] rtc-cmos: convert RTC_AIE/RTC_UIE to rtc irq API
> 
> Drop ioctl function that handles RTC_AIE/RTC_UIE, and use instead the
> rtc subsystem API (alarm_irq_enable/update_irq_enable callbacks).
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

 Looks nice. David?

> --
> Still, couldn't an oops still trigger with this with dev_set_drvdata after
> rtc_device_register? Lets say, a small test program like this:

 dev_set_drvdata should be called before rtc_device_register. I guess
 I'll have to patch every single driver :(


 [...]

> Compiled and run with similar udev rule. It's very unlikely, and I couldn't
> get an oops anymore unless I moved dev_set_drvdata down in cmos_do_probe in
> my test machine, but should be a possibility?

 I don't think so.
 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

