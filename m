Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXHVQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXHVQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764640AbXHVQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:27:14 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:38042 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbXHVQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BvcN564aC2oEiLTrEvlbxu3Ha3l3+UjD2XLePjIDjf0aSbxxViyI8LFiiaIXlAQNzKJWDwCSNxXzEe4WF4s3O2mybIGYJm+natMDQFchiwuHhlqV3uH+vnIaYs2/ZRIpgOiQtr3g3TNJsvmjHkz0exx74IrL317A9PfK8lMm6vs=
Message-ID: <88dfed9d0708220927r40f4bc64t833a3383159387e9@mail.gmail.com>
Date: Thu, 23 Aug 2007 00:27:11 +0800
From: hufey <hufeyy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: strange probe order issue after platform_add_devices()
In-Reply-To: <88dfed9d0708180729s1837b56brf81e905045039561@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <88dfed9d0708180729s1837b56brf81e905045039561@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems never reach to the list...

On 8/18/07, hufey <hufeyy@gmail.com> wrote:
> Hi list,
>
> I am facing a very strange issue about device probe order.
> I have a piece of code to support network interface card for an embedded box.
>
> It likes following:
>
> ...
> static struct platform_device *custom_devices[] __initdata = {
>           &a_device,
>           &b_device,
>           &c_device,
> };
>
> static int __init device_init()
> {
>            return platform_add_devices(custom_devices,
> ARRAY_SIZE(custom_devices);
> }
>
> subsys_initcall(device_init);
>
> /* end */
>
> This code works good with kernel 2.6.11. After platform_add_devices()
> is executed, a_device's probe function will be called first then
> b_device's probe function be called.
> I merged it to 2.6.17, but strange thing is b_device's probe be called
> first always now.
> Since b_device probe depends on a_device, so it always fails now.
>
> Does anyone know how to fix it? Or give me the hint about how kernel
> decide which device be called to probe in order by what mechanism?
>
> Thanks in advance and best regards,
> hufeyy
>
