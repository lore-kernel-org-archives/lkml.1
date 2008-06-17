Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYFQOAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYFQOAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYFQOA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:00:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:38817 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756833AbYFQOA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:00:28 -0400
Date: Tue, 17 Jun 2008 16:00:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Philippe Troin <phil@fifi.org>
cc: linux-kernel@vger.kernel.org, arbrandes@gmail.com
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <871w2xnehf.fsf@old-tantale.fifi.org>
Message-ID: <Pine.LNX.4.64.0806171557440.10085@jikos.suse.cz>
References: <871w2xnehf.fsf@old-tantale.fifi.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Philippe Troin wrote:

> Jiri & all,
> What's the status on this bug?
> I used this patch for 2.6.24:
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 0b27da7..fc6e77e 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -802,6 +802,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>  		case HID_UP_LOGIVENDOR:
>  			set_bit(EV_REP, input->evbit);
>  			switch(usage->hid & HID_USAGE) {
> +				case 0x000: map_key_clear(KEY_TV);
>  				/* Reported on Logitech Ultra X Media Remote */
>  				case 0x004: map_key_clear(KEY_AGAIN);		break;
>  				case 0x00d: map_key_clear(KEY_HOME);		break;
> @@ -1039,6 +1040,28 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
>  		return;
>  	}
>  
> +	/* "Sleep" key */
> +	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
> +			((usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK) &&
> +			((usage->hid & 0xf0) == 0x80)  &&
> +			((usage->hid & 0xf) == 0x2)) {
> +		input_event(input, usage->type, usage->code, 1);
> +		input_sync(input);
> +		input_event(input, usage->type, usage->code, 0);
> +		input_sync(input);
> +		return;
> +	}
> +	/* "TV" key */
> +	if (hid->vendor == 0x0c16 && hid->product == 0x0002 &&
> +			((usage->hid & HID_USAGE_PAGE) == HID_UP_LOGIVENDOR) &&
> +			((usage->hid & HID_USAGE) == 0x0000)) {
> +		input_event(input, usage->type, usage->code, 1);
> +		input_sync(input);
> +		input_event(input, usage->type, usage->code, 0);
> +		input_sync(input);
> +		return;
> +	}
> +
>  	/* Handling MS keyboards special buttons */
>  	if (IS_MS_KB(hid) && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
>  		int key = 0;
> It was working fine.

Hi,

The patch didn't add complete support for this device, there still has 
been problem with "TV" key, and I have asked Adolfo to perform a test with 
debugging patch, but there seems to be no response so far [1]

Adolfo (added to CC), has there been any progress, so that we could 
proceed with merging the patch adding proper support for this HW?

Thanks,

[1]

-- 
Jiri Kosina
SUSE Labs
