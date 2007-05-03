Return-Path: <linux-kernel-owner+w=401wt.eu-S1767337AbXECCiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767337AbXECCiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767339AbXECCiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:38:46 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:29541 "EHLO
	asav15.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767337AbXECCip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:38:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAJnoOEZKhRO4W2dsb2JhbACBZI4lHQ0GEA
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jan Kratochvil <honza@jikos.cz>
Subject: Re: [PATCH 1/3] xpad.c: Added flags into xpad_device structure and removed dpad_mapping.
Date: Wed, 2 May 2007 22:38:35 -0400
User-Agent: KMail/1.9.3
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
References: <Pine.LNX.4.64.0705021644580.13550@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705021644580.13550@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705022238.36454.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Wednesday 02 May 2007 11:01, Jan Kratochvil wrote:
> This changes are expected to simplify further improves of this driver,
> We will need to add information if the driver is xbox360 device or not.
> 
> Second option was to simply add u8 is_360, but what if we'll need to know
> if device is a wheel? Or if the device can have keyboard (or headset) attached.
> 

...

> -#define MAP_DPAD_TO_BUTTONS    0
> -#define MAP_DPAD_TO_AXES       1
> -#define MAP_DPAD_UNKNOWN       -1
> +#define XPAD_FLAGS_DPAD_TO_BUTTONS    (1 << 0)
> +#define XPAD_FLAGS_DPAD_TO_AXES       (1 << 1)
> +#define XPAD_FLAGS_DPAD_UNKNOWN       (1 << 2)
> 

Turning this into bitmaps suggests that all of these could be set which is
not the case. Since there are 3 spare bytes in xpad_device structure to
use for additional flags/bitmaps I'd leave dpad_mapping alone.

-- 
Dmitry
