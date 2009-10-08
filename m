Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbZJHS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbZJHS3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbZJHS3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:29:16 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:41260 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZJHS3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U4qcdy4jvmmzGGpVhT3PeuTBPHm8h/wjzomSV6s3tCqPG/YSnYCbRr8Z7bbJ8q28cR
         XgT/+3OWuLqICu/b4RD3+QvJka5/8iRzzCcM6i6NtkyJuxGebu8MLAbJg+tqN3fj5QGU
         rffHBMpWKTNd9GcXUznkCtb8PD8xmw98kz1ws=
MIME-Version: 1.0
In-Reply-To: <20091007061822.GA7602@july>
References: <20091007061822.GA7602@july>
Date: Thu, 8 Oct 2009 23:58:37 +0530
Message-ID: <5d5443650910081128l58f45148m87735185a0094c31@mail.gmail.com>
Subject: Re: [PATCH 5/6] haptic: Samsung SoCs PWM controlled haptic support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Bill Gatliff <bgat@billgatliff.com>, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Bill Gatliff.

Hi Kyungmin,

Most of the driver looks fine. I have only one generic comment, but
not for this driver:

- Someone should really work on getting PWM framework (may be the one
written by Bill Gatliff) into the kernel, because
  if we don't do this and if new PWM controller provides it's own APIs
then we can't leverage the chips using them, like the
  case here for ISA1000 and ISA1200. These chips are using the pwm
APIs exported by Samsung PWM controller, but it would
  be painful to integrate other PWM controller if that has slightly
little different API due to its nature.

  So, it would be better to get one generic PWM framework mainline in
the kernel.

> +static int __devexit samsung_pwm_haptic_remove(struct platform_device *pdev)
> +{
> +       struct samsung_pwm_haptic *haptic = platform_get_drvdata(pdev);
> +
> +       samsung_pwm_haptic_set(&haptic->cdev, HAPTIC_OFF);
> +       del_timer_sync(&haptic->timer);

cancel_work_sync ?


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
