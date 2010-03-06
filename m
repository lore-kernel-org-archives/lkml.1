Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0CFSs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 13:48:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0CFSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 13:48:25 -0500
Date: Sat, 6 Mar 2010 19:48:19 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Petr Vandrovec <petr@vmware.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Jeff Chua <jeff.tw.chua@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for
 vmware 7.0.1
Message-ID: <20100306184819.GA6832@fancy-poultry.org>
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com>
 <4B91FA42.8020400@vmware.com>
 <20100306093306.GA27247@core.coreip.homeip.net>
 <201003061212.51110.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003061212.51110.oliver@neukum.org>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V01U2FsdGVkX18r/4IdKvLSAXsWrhri5bzHrla806bazm1JCgX
 59Ysbcor/RkZmXC7ckbhzS0gfY/UGipxfnsvthndM7t2Cggjvg
 gtC7/hHwjMsmB2FoaleLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.03.2010, Oliver Neukum wrote:

> From: Oliver Neukum <oliver@neukum.org>
> Date: Sat, 6 Mar 2010 12:09:41 +0100
> Subject: [PATCH] usb: usbfs: Fix deadlock of khubd
>
> The caller of usbfs_conn_disc_event() already holds usbfs_mutex.
> Don't take it again.
>
> Signed-off-by: Oliver Neukum <neukum@b1-systems.de>
> ---
>  drivers/usb/core/devices.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
> index c83c975..08def6b 100644
> --- a/drivers/usb/core/devices.c
> +++ b/drivers/usb/core/devices.c
> @@ -155,11 +155,10 @@ static const struct class_info clas_info[] =
>
>  /*****************************************************************/
>
> +/* the caller holds usbfs_mutex */
>  void usbfs_conn_disc_event(void)
>  {
> -     mutex_lock(&usbfs_mutex);
>       conndiscevcnt++;
> -     mutex_unlock(&usbfs_mutex);
>       wake_up(&deviceconndiscwq);
>  }

I had a bug on my system which occured when I connected an USB mp3
player more than once:

When plugged in the first time, the device worked as expected. After
pulling it, it didn't get recognized again when plugged it.
Only a reboot did help.  2.6.33 final is fine, 2.6.33-gitX isn't.

Your patch, applied to -git11, did fix this.

Thanks,
Heinz.
