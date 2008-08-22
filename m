Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYHVSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYHVSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYHVSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:25:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44006 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752095AbYHVSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:25:12 -0400
Date: Fri, 22 Aug 2008 14:25:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
In-Reply-To: <200808222157.29299.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0808221422130.2230-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Andrey Borzenkov wrote:

> It looks even funnier. Right now I am running with commits
> 38b375d9610e2467cb793a84d17c6f65e44cdb39 *and*
> e872154921a6b5256a3c412dd69158ac0b135176 reverted. I.e. this should be
> the state which hopelessly failed in 2.6.26-rc. It seems to be doing
> quite well now in 2.6.27-rc.
> 
> "git revert e872154921a6b5256a3c412dd69158ac0b135176" gives me this
> one liner patch:
> 
> commit f3cf9ad86ee76077d1c6be9af7d197aa13ccdff9
> Author: Andrey Borzenkov <arvidjaar@mail.ru>
> Date:   Fri Aug 22 21:15:26 2008 +0400
> 
>     Revert "USB: don't explicitly reenable root-hub status interrupts"
> 
>     This reverts commit e872154921a6b5256a3c412dd69158ac0b135176.
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 107e1d2..d30f822 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3086,6 +3086,11 @@ static void hub_events(void)
>                 if (!hdev->parent && !hub->busy_bits[0])
>                         usb_enable_root_hub_irq(hdev->bus);
> 
> +               /* If this is a root hub, tell the HCD it's okay to
> +                * re-enable port-change interrupts now. */
> +               if (!hdev->parent && !hub->busy_bits[0])
> +                       usb_enable_root_hub_irq(hdev->bus);
> +
>  loop_autopm:
>                 /* Allow autosuspend if we're not going to run again */
>                 if (list_empty(&hub->event_list))
> 
> Either my git tree is completely botched or most parts were already reverted
> before.

_Something_ is completely botched.  e872154 is much bigger than what 
you quoted above.

The commit you really want to revert is
09ca8adbe9f724a7e96f512c0039c4c4a1c5dcc0.

Alan Stern

