Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYLCNBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYLCNBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYLCNBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:01:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:30373 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYLCNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:01:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:user-agent:mime-version:to:cc:subject:references:in-reply-to
         :content-type:content-transfer-encoding:from:sender:message-id;
        b=VVoxZFuI8tFhGGdkAb2s7j00DhTaZwYrzj/2G6TcXtbKeQjIih5vutbmyVLEuW6Odb
         cYjP3ljm1ERN9Aou0bF089ZnzwxCg+l1CsjBMahOiuy71POGE4GX0shJSjrk1ZjebxXm
         MeI1PNaSP9wYiC4PQw3jxXN/NhqAkymR6GNhA=
Date: Wed, 03 Dec 2008 13:01:25 +0000
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matt_Domsch@dell.com, greg@kroah.com, linux-acpi@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2 update] misc: Add dell-laptop driver
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202115029.2b9d1153.akpm@linux-foundation.org> <20081202201645.GB31620@srcf.ucam.org>
In-Reply-To: <20081202201645.GB31620@srcf.ucam.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: none <alan-jenkins@tuffmail.co.uk>
Message-ID: <49368329.19e7300a.0526.5a68@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> misc: Add dell-laptop driver
>     
> Add a driver for controling Dell-specific backlight and rfkill interfaces.
> This driver makes use of the dcdbas interface to the Dell firmware to allow
> the backlight and rfkill interfaces on Dell systems to be driven through the
> standardised sysfs interfaces.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> ---
>
> Contains Andrew's suggested updates, plus a fix for a leak on the init 
> error path.
>   

Sorry, I should have mentioned this in my first message:

> +	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
> +		wifi_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WLAN);
> +		if (!wifi_rfkill)
> +			goto err_wifi;
> +		wifi_rfkill->name = "dell-wifi";
> +		wifi_rfkill->toggle_radio = dell_wifi_set;
> +		wifi_rfkill->get_state = dell_wifi_get;
>   

The rfkill doc (and code) say that you also need to initialize
wifi_rfkill->state to the current state of the hardware.

> +		ret = rfkill_register(wifi_rfkill);
> +		if (ret)
> +			goto err_wifi;
> +	}
> +

Regards
Alan
