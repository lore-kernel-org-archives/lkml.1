Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0BCOSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:18:33 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36774 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab0BCOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:18:30 -0500
Subject: Re: [PATCH 3/3] HID: Enable Sixaxis controller over Bluetooth
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bastien Nocera <hadess@hadess.net>, Michael Poole <mdpoole@troilus.org>,
       "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1002031349550.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	 <1264783166.29532.5302.camel@localhost.localdomain>
	 <87iqakifm8.fsf@troilus.org>
	 <1264860663.29532.7887.camel@localhost.localdomain>
	 <87bpg7glf7.fsf@troilus.org>
	 <1265190440.32444.8417.camel@localhost.localdomain>
	 <alpine.LNX.2.00.1002031202040.15395@pobox.suse.cz>
	 <alpine.LNX.2.00.1002031343500.15395@pobox.suse.cz>
	 <alpine.LNX.2.00.1002031349550.15395@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 06:17:30 -0800
Message-ID: <1265206650.31341.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Now that hid_output_raw_report works, port the PS3 Sixaxis
> Bluetooth quirk from user-space, into kernel-space.
> 
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Marcel Holtmann <marcel@holtmann.org>
 
> -	ret = sony_set_operational(hdev);
> +	if (hdev->bus == BUS_USB)
> +		ret = sony_set_operational(hdev);
> +	else if (hdev->bus == BUS_BLUETOOTH)
> +		ret = sony_set_operational_bt(hdev);
> +	else
> +		ret = 0;
> +

I would do sony_set_operational_usb() and sony_set_operational_bt() and
also turn this into a switch statement for better readability.

Regards

Marcel


