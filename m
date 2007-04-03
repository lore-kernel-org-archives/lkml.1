Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXDCIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXDCIr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbXDCIr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:47:58 -0400
Received: from styx.suse.cz ([82.119.242.94]:44348 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933214AbXDCIr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:47:57 -0400
Date: Tue, 3 Apr 2007 10:52:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
Subject: Re: usb hid: reset NumLock
In-Reply-To: <20070402161225.2866c002.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
 <Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz> <20070401222410.2ff7ecd7.zaitcev@redhat.com>
 <Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz> <20070402161225.2866c002.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Pete Zaitcev wrote:

> How about this?

Looks quite fine to me.

But in case that Dmitry's patch "Input: add generic suspend and resume for 
uinput devices" fixes your issue too, I wouldn't merge it as it won't be 
needed. Could you please let me know?

> @@ -947,6 +989,8 @@ static const struct hid_blacklist {
>  
>  	{ USB_VENDOR_ID_CIDC, 0x0103, HID_QUIRK_IGNORE },
>  
> +	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
> +

As this quirk is only needed once in the initialization method, we could 
probably get rid of it and just put and explicit test for PID and VID 
there (with apropriate comment). We can't afford wasting quirk entries, as 
we are slowly running out of them.

Depends on whether this is going to be needed for > 1 PID.

> I wasn't sure where to place the function, so I just put it above its 
> user, to signify that it's special-casing. Also, it's unclear where to 
> put the quirk entry and defines. There's a comment saying that they are 
> sorted alphabetically by quirk, but apparently the order was violated 
> with more recent additions.

Yep, the blacklist is ugly. I have a patch moving it to the proper place 
and rearranging it to be sorted again, queued for 2.6.22.

Thanks,

-- 
Jiri Kosina
