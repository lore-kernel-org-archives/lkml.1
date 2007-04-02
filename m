Return-Path: <linux-kernel-owner+w=401wt.eu-S965787AbXDBUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965787AbXDBUKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965795AbXDBUKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:10:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:11632 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965787AbXDBUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rklfcBlMsVnCScD5tT/ktApN2U4+IrTmQVC2o34Q4Clhj41rDvI1PcTDN/mxGACUaFqigQjuZfVXIqURPneZviiS6fTxIgr/cHIyYWDoBKbYfDXwt84Tvy+eKZAbo/4wYXxlGeccTPvEnE0My4114lkUIj6L7FN8E7txnl9ZGB4=
Message-ID: <d120d5000704021310r777e1796rf2025d873404afeb@mail.gmail.com>
Date: Mon, 2 Apr 2007 16:10:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform drivers
Cc: "Greg KH" <gregkh@suse.de>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Andres Salomon" <dilinger@debian.org>
In-Reply-To: <200703311455.38490.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703311455.38490.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/07, David Brownell <david-b@pacbell.net> wrote:
> @@ -349,6 +360,13 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
>  *     memory allocated for the device allows drivers using such devices
>  *     to be unloaded iwithout waiting for the last reference to the device
>  *     to be dropped.
> + *
> + *     This interface is primarily intended for use with legacy drivers
> + *     which probe hardware directly.  Because such drivers create device
> + *     nodes themselves, rather than letting system infrastructure handle
> + *     such device enumeration tasks, they don't fully conform to the Linux
> + *     driver model.  In particular, when such drivers are built as modules,
> + *     they can't be "hotplugged".
>  */
>  struct platform_device *platform_device_register_simple(char *name, unsigned int id,

I find this comment misleading. Many of these drivers do not create
any devices (as in /dev/xxx) but rather create underlying hardware
abstraction objects.


-- 
Dmitry
