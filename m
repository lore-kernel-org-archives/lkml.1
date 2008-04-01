Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYDAHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYDAHsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYDAHr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:47:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:58078 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYDAHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jmQIwUIC0WJyHdEckADBrQ4fyDKarVhpRdOrEbjSxEAkHn+KmhX1kHhqeUfEHx8jd+VfKWcv8xBT1XAJpwjZ2Vgeq+RKb6MYQvY/KCAMT9xVizbkZIOnzcSELIehNA7ukTFHUyvxxrm1QDZWgpwYBdtRwoYHmlgTJ/ClAikBNh4=
Message-ID: <45a44e480804010047m36a9b8e3p97910308ed5677fb@mail.gmail.com>
Date: Tue, 1 Apr 2008 00:47:54 -0700
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: Clarifying platform_device_unregister
Cc: "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080401051947.GD18041@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
	 <20080401051947.GD18041@anvil.corenet.prv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:19 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>  On Mon, Mar 31, 2008 at 09:14:35PM -0400, Jaya Kumar wrote:
>  >         mytest_device->dev.platform_data = &mydata;
>
>  Platform device code does kfree(pdev->dev.platform_data) unpon
>  unregistration, so it is not a good idea to assign address of
>  statically-allocated variable here. You should be using:
>
>         platform_device_add_data(mytest_device, &mydata, sizeof(mydata));
>

That's interesting. I noticed though that a lot of platform device
code assigns a statically allocated structure to platform_data. For
example:

arch/arm/mach-pxa/corgi_pm.c
static struct sharpsl_charger_machinfo corgi_pm_machinfo = {
...
}
        corgipm_device->dev.platform_data = &corgi_pm_machinfo;

same with spitz_pm.c.

egrep "platform_data.*=.*\&" *.c shows quite a lot of users doing
that. I guess most of these below are probably okay since these
drivers can't be rmmoded.

corgi.c:                .platform_data  = &corgi_scoop_setup,
corgi.c:                .platform_data  = &corgi_bl_machinfo,
corgi.c:                .platform_data  = &corgi_ts_machinfo,
corgi_lcd.c:            .platform_data = &corgi_fb_info,
corgi_pm.c:     corgipm_device->dev.platform_data = &corgi_pm_machinfo;
generic.c:              .platform_data  = &pxa_udc_info,
lpd270.c:                       .platform_data  = &lpd270_flash_data[0],
lpd270.c:                       .platform_data  = &lpd270_flash_data[1],
lubbock.c:              .platform_data  = &pxa_ssp_master_info,
lubbock.c:      .platform_data  = &ads_info,
lubbock.c:                      .platform_data = &lubbock_flash_data[0],
lubbock.c:                      .platform_data = &lubbock_flash_data[1],
mainstone.c:    .dev            = { .platform_data = &mst_audio_ops },
mainstone.c:                    .platform_data = &mst_flash_data[0],
mainstone.c:                    .platform_data = &mst_flash_data[1],
poodle.c:               .platform_data  = &poodle_scoop_setup,
poodle.c:               .platform_data  = &poodle_ts_machinfo,
spitz.c:                .platform_data  = &spitz_scoop_setup,
spitz.c:                .platform_data  = &spitz_scoop2_setup,
spitz.c:                .platform_data  = &spitz_bl_machinfo,
spitz.c:                .platform_data  = &spitz_ts_machinfo,
spitz_pm.c:     spitzpm_device->dev.platform_data = &spitz_pm_machinfo;
tosa.c:                 .platform_data  = &tosa_scoop_setup,
tosa.c:                 .platform_data  = &tosa_scoop_jc_setup,
trizeps4.c:             .platform_data = &trizeps4_flash_data,
