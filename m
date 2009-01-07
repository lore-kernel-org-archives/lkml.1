Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZAGLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZAGLbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZAGLbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:31:09 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40569 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZAGLbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:31:08 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [GIT] HID updates for 2.6.29
Date: Wed, 7 Jan 2009 12:30:44 +0100
User-Agent: KMail/1.9.10
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.1.10.0901040115060.5377@jikos.suse.cz> <4963EE3C.3070106@googlemail.com> <alpine.LNX.1.10.0901071049400.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901071049400.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071230.45993.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 07 January 2009 11:22:27 schrieb Jiri Kosina:
> On Wed, 7 Jan 2009, Gabriel C wrote:

> I believe this is caused by forgotten assignment in usb_register_dev() 
> error handling introduced in 079034073fa (added Oliver to CC).

Yes, it seem I caused this. Sorry.
  
> Commit 079034073fa ("HID: hiddev cleanup -- handle all error conditions
> properly") by mistake removed proper initialization of hid->hiddev pointer
> in hiddev_connect() in case usb_register_dev() succeeds for the hiddev node.
> Put it properly back in place.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/usbhid/hiddev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index 6a98f9f..1928e8a 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -885,6 +885,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
>  	} else {
>  		hid->minor = usbhid->intf->minor;
>  		hiddev_table[usbhid->intf->minor - HIDDEV_MINOR_BASE] = hiddev;
> +		hid->hiddev = hiddev;

It seems to me that this is still a race condition. What prevents open()
from being called before this is set?

	Regards
		Oliver
