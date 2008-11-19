Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYKSM6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYKSM6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYKSM6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:58:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:40495 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752470AbYKSM6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:58:41 -0500
Date: Wed, 19 Nov 2008 13:58:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
In-Reply-To: <49232910.2030309@seas.upenn.edu>
Message-ID: <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz>
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu> <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz> <49232910.2030309@seas.upenn.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008, Rafi Rubin wrote:

> +static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> +		struct hid_field *field, struct hid_usage *usage,
> +		unsigned long **bit, int *max)
> +{
> +   if ( (usage->hid & HID_USAGE_PAGE) == HID_UP_DIGITIZER &&
> +         (usage->hid & 0xff) == 0x47) {
> +      nt_map_key_clear(BTN_TOOL_DOUBLETAP);
> +      return 1;
> +   }
> +   return 0;
> +}

Could you please keep standard linux-kernel indenting style? I.e. 
something like

static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
		struct hid_field *field, struct hid_usage *usage,
		unsigned long **bit, int *max)
{
	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_DIGITIZER &&
			(usage->hid & 0xff) == 0x47) {
		nt_map_key_clear(BTN_TOOL_DOUBLETAP);
		return 1;
	}
	return 0;
}


> +
> +static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
> +		struct hid_field *field, struct hid_usage *usage,
> +		unsigned long **bit, int *max)
> +{
> +	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);

This could be removed, as it is never used, right?

> +HID_COMPAT_LOAD_DRIVER(ntrig);

Also please don't forget to add HID_COMPAT_CALL_DRIVER() entry into 
hid-dummy.c

Besides that it looks OK, so please resend with the above issues fixed, 
and I'll queue it in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
