Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbZKZQTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbZKZQTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbZKZQTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:19:44 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:50143 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZKZQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:19:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=v6PjgcebyJwCeMJdpr0xB5IMACXzI9OHTe1E6S9yuZ9cX7+0fmvoiEVzQPSDa740jG
         NReA94s3dE6Nvq/rTLQ48ZHEB31mVD3NvFuMf5jiN+iP9dfv++aPCSoF+uidIXHi5u1D
         rlz8VJ6HGvjy4TzCugkDL/EyQwJVOvetO1H1s=
Message-ID: <4B0EAAA2.1080708@lwfinger.net>
Date: Thu, 26 Nov 2009 10:19:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] b43legacy: Port b43 rfkill fix to b43legacy
References: <1259246955-24386-1-git-send-email-stefan.bader@canonical.com>
In-Reply-To: <1259246955-24386-1-git-send-email-stefan.bader@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2009 08:49 AM, Stefan Bader wrote:
> Resending this. I believe I messed up with the recipients the last time.
> 
> -Stefan
> 
>>From d800aef9db80ba1168f336791f4c5e8d4d0517c3 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Thu, 19 Nov 2009 14:52:22 -0600
> Subject: [PATCH] b43legacy: Port b43 rfkill fix to b43legacy
> 
> BugLink: https://bugs.launchpad.net/bugs/476154
> 
> "b43: Fix Bugzilla #14181 and the bug from the previous 'fix'" fixed
> a crash with the b43 driver, that happens if the radio switch is
> turned off.
> The same happens when using the b43legacy driver and it was verified,
> that the same changes just work in that case too.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/net/wireless/b43legacy/rfkill.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43legacy/rfkill.c b/drivers/net/wireless/b43legacy/rfkill.c
> index 8783022..ad7083e 100644
> --- a/drivers/net/wireless/b43legacy/rfkill.c
> +++ b/drivers/net/wireless/b43legacy/rfkill.c
> @@ -34,7 +34,8 @@ bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
>  		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
>  			return 1;
>  	} else {
> -		if (b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
> +		if (b43legacy_status(dev) >= B43legacy_STAT_STARTED &&
> +		    b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
>  		    & B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
>  			return 1;
>  	}

This issue is already addressed by the patch in
http://marc.info/?l=linux-wireless&m=125902335810157&w=2.

Larry

