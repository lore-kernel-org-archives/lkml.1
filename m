Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYL2Lgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYL2Lgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYL2LgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:36:25 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:45407 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYL2LgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:36:24 -0500
Date: Mon, 29 Dec 2008 11:36:21 +0000
From: Nick Warne <nick@ukfsn.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range
 of hardware
Message-ID: <20081229113621.1a64caea@sauron.linicks.net>
In-Reply-To: <20081112165650.GA15594@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net>
	<20081112131427.1bbc2a7c@palantir.linicks.net>
	<20081112165650.GA15594@srcf.ucam.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 16:56:50 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Does this work?
> 
> diff --git a/drivers/input/keyboard/atkbd.c
> b/drivers/input/keyboard/atkbd.c index 22016ca..15479ef 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -1460,6 +1460,15 @@ static struct dmi_system_id
> atkbd_dmi_quirk_table[] __initdata = { .driver_data =
> atkbd_dell_laptop_keymap_fixup, },
>  	{
> +		.ident = "Dell Laptop",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer
> Corporation"),
> +			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /*
> Portable */
> +		},
> +		.callback = atkbd_setup_fixup,
> +		.driver_data = atkbd_dell_laptop_keymap_fixup,
> +	},
> +	{
>  		.ident = "HP 2133",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> 

Hi Matthew,

I see this didn't make into the 2.6.28 release, and a lot of Ubuntu
users are being bitten by it - I also assume that the Ubuntu kernel
guys will not add it until it is officially applied, and they will then
backport it.

The Ubuntu bug report confirms this works OK for people:

https://bugs.launchpad.net/ubuntu/+source/acpid/+bug/285323

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
