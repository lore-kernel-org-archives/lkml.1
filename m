Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYKLRYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYKLRYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYKLRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:24:32 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:39917 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYKLRYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:24:31 -0500
Date: Wed, 12 Nov 2008 17:24:29 +0000
From: Nick Warne <nick@ukfsn.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range
 of hardware
Message-ID: <20081112172429.674c4ff3@palantir.linicks.net>
In-Reply-To: <20081112165650.GA15594@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net>
	<20081112131427.1bbc2a7c@palantir.linicks.net>
	<20081112165650.GA15594@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
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

Matthew,

The original worked for me fine, and a lot of other people as our Dell
laptops produce 'Dell Inc.' as vendor.  But other peoples return 'Dell
Computer Corporation' and thus it didn't work for them.

But how you determine if these certain laptops produce a keypress
release I don't know with having all of them at hand...

So it needs BOTH 'Dell Inc.' and 'Dell Computer Corporation' to cover
these laptops (I guess), as per the info I got from people running
dmidecode:

http://ubuntuforums.org/showthread.php?t=978973

Nick

-- 
Free Software Foundation Associate Member 5508
