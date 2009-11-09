Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZKIT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZKIT1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 14:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZKIT07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 14:26:59 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48127 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbZKIT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 14:26:58 -0500
Date: Mon, 9 Nov 2009 19:27:04 +0000
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-acpi@vger.kernel.org, Corentin Chary <corentin.chary@gmail.com>,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net
Subject: Re: [PATCH] Add Lenovo SL hotkey support on asus-laptop
Message-ID: <20091109192704.GC15159@caffeine.csclub.uwaterloo.ca>
References: <1257765266-6669-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257765266-6669-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 07:14:26PM +0800, Ike Panhc wrote:
> Lenovo SL series laptop has a very similar DSDT with Asus laptops. We can
> easily have the extra ACPI function support with little modification in
> asus-laptop.c

Wow, so my SL 500 should be happy with the asus-laptop module loaded?
That seems weird and wrong in some way, but if it works, I will be
quite happy.  Nice work.

> Here is the hotkey enablement for Lenovo SL series laptop.
> 
> This patch will enable the following hotkey:
>  - Volumn Up
>  - Volumn Down
>  - Mute
>  - Screen Lock (Fn+F2)
>  - Battery Status (Fn+F3)
>  - WLAN switch (Fn+F5)
>  - Video output switch (Fn+F7)
>  - Touchpad switch (Fn+F8)

Yay!  Whoohoo!

>  - Screen Magnifier (Fn+Space)
> 
> The following function of Lenovo SL laptop is still need to be enabled:
>  - Hotkey: KEY_SUSPEND (Fn+F4), KEY_SLEEP (Fn+F12), Dock Eject (Fn+F9)
>  - Rfkill for bluetooth and wlan

I am OK with the hardware switch for now. :)

>  - LenovoCare LED
>  - Hwmon for fan speed
>  - Fingerprint scanner

I have read that some people have got that working with various bits of
user space code.

>  - Active Protection System

Yeah that one would be nice to fix.  It works under windows with the
driver installed of course.

I will have to go try it out.

-- 
Len Sorensen

> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  drivers/platform/x86/asus-laptop.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index b39d2bb..a365636 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -221,6 +221,7 @@ static struct asus_hotk *hotk;
>   */
>  static const struct acpi_device_id asus_device_ids[] = {
>  	{"ATK0100", 0},
> +	{"ATK0101", 0},
>  	{"", 0},
>  };
>  MODULE_DEVICE_TABLE(acpi, asus_device_ids);
> @@ -293,6 +294,11 @@ struct key_entry {
>  enum { KE_KEY, KE_END };
>  
>  static struct key_entry asus_keymap[] = {
> +	{KE_KEY, 0x02, KEY_SCREENLOCK},
> +	{KE_KEY, 0x05, KEY_WLAN},
> +	{KE_KEY, 0x08, BTN_TOUCH},
> +	{KE_KEY, 0x17, KEY_ZOOM},
> +	{KE_KEY, 0x1f, KEY_BATTERY},
>  	{KE_KEY, 0x30, KEY_VOLUMEUP},
>  	{KE_KEY, 0x31, KEY_VOLUMEDOWN},
>  	{KE_KEY, 0x32, KEY_MUTE},
> @@ -312,7 +318,9 @@ static struct key_entry asus_keymap[] = {
>  	{KE_KEY, 0x5F, KEY_WLAN},
>  	{KE_KEY, 0x60, KEY_SWITCHVIDEOMODE},
>  	{KE_KEY, 0x61, KEY_SWITCHVIDEOMODE},
> +	{KE_KEY, 0x62, KEY_SWITCHVIDEOMODE},
> +	{KE_KEY, 0x63, KEY_SWITCHVIDEOMODE},
>  	{KE_KEY, 0x6B, BTN_TOUCH}, /* Lock Mouse */
>  	{KE_KEY, 0x82, KEY_CAMERA},
>  	{KE_KEY, 0x8A, KEY_PROG1},
>  	{KE_KEY, 0x95, KEY_MEDIA},
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
