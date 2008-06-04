Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYFDGIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYFDGIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYFDGIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:08:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46994 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYFDGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:08:00 -0400
Date: Tue, 3 Jun 2008 22:38:05 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, bersace03@laposte.net,
       johannes@sipsolutions.de
Subject: Re: [PATCH] Firmware loader driver for USB Apple iSight camera
Message-ID: <20080604053805.GB13998@kroah.com>
References: <20080520190628.GA14580@srcf.ucam.org> <20080602192103.GA31589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602192103.GA31589@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 09:21:03PM +0200, Ingo Molnar wrote:
> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > Uninitialised Apple iSight drivers present with a distinctive USB ID. 
> > Once firmware has been uploaded, they disconnect and reconnect with a 
> > new ID. At this point they can be driven by the uvcvideo driver. As 
> > this is unique to the Apple cameras and not functionality shared by 
> > any other UVC devices, it makes sense to provide the firmware loading 
> > functionality in a separate driver. This driver will read an isight.fw 
> > file extracted from the Apple driver using the tools at 
> > http://bersace03.free.fr/ift/ and upload it to the camera. It will 
> > also handle the case where the device loses its firmware during 
> > hibernation and must have it reloaded.
> 
> this caused a build failure - find the fix below. (fix can also be 
> pulled/cherry-picked from -tip's tip/out-of-tree topic branch)
> 
> 	Ingo
> 
> -------------------->
> commit 1f910d33b2084d03267db20359472891f95b45b4
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jun 2 21:07:27 2008 +0200
> 
>     USB: fix build bug in USB_ISIGHTFW
>     
>     -tip tree testing found this build bug:
>     
>       drivers/built-in.o: In function `isight_firmware_load':
>       isight_firmware.c:(.text+0x1ade08): undefined reference to `request_firmware'
>       isight_firmware.c:(.text+0x1adf9c): undefined reference to `release_firmware'
>     
>     select FW_LOADER in USB_ISIGHTFW.

Thanks, I'll add this to my queue.

greg k-h
