Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbYADQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbYADQbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYADQbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:31:05 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:32257 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752310AbYADQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:31:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Ojc3lg5Q0i/FswPOPwlj3XgCXn900SuFitR1aXoP32OgvD2AJDNiKApnysZIjFlg/edVEC06tgrjVnGWJOKk+OlTjeWbbOCjywRt23GalBYvE0AbVoQmZqxVj2Kq9eRn5D30Nmp2KWlbnivpcJh7/5muWbSAVBmSqyc/0PBmKr4=  ;
X-YMail-OSG: Z33p7R0VM1m3rJdxBSRw8hji48uWfnGAb1EwmQx2DbTIoE0R
Date: Fri, 04 Jan 2008 08:31:01 -0800
From: David Brownell <david-b@pacbell.net>
To: yi.y.yang@intel.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
 "unsupported" if wakeup feature isn't supported by a device
Cc: linux-kernel@vger.kernel.org
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080104163101.EDC02115203@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch changes empty output to "unsupported" in order that a user knows
> wakeup feature isn't supported by this device when he/she
> 'cat /sys/devices/.../power/wakeup', please consider to apply, thanks.

I don't much like this patch.  Not just for the technical reasons
mentioned in my previous note ... but also because it doesn't update
the documention at the top, which clearly states that "\n" is
returned for "temporary or permanent inability to issue wakeup".
And then it gives the example I gave before ...

Though I suppose a patch that changes the *entire* userspace interface,
(which includes its documentation, and all out-of-tree users) would have
shown more clearly why it wasn't a good idea.  ;)


> --- a/drivers/base/power/sysfs.c	2008-01-04 16:50:54.000000000 +0800
> +++ b/drivers/base/power/sysfs.c	2008-01-04 17:14:42.000000000 +0800
> @@ -49,7 +49,7 @@ wake_show(struct device * dev, struct de
>  {
>  	return sprintf(buf, "%s\n", device_can_wakeup(dev)
>  		? (device_may_wakeup(dev) ? enabled : disabled)
> -		: "");
> +		: "unsupported");
>  }
>  
>  static ssize_t
>
>
