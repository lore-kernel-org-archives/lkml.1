Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0BWDMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 22:12:24 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55797 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab0BWDMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 22:12:23 -0500
X-Sasl-enc: PLUzdqnOAn8VhFf+GiZYjlZoVIKqo5oWGsBozlP1GKgz 1266894742
Date: Tue, 23 Feb 2010 00:12:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: fix return value of volume callbacks
Message-ID: <20100223031220.GI30470@khazad-dum.debian.net>
References: <4B825228.8050405@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B825228.8050405@ladisch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Clemens Ladisch wrote:
> Fix up the volume status setting functions to return a non-zero value if
> the control value has changed, so that the ALSA framework can correctly
> generate control change notifications.

Please explain...

> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- linux/drivers/platform/x86/thinkpad_acpi.c
> +++ linux/drivers/platform/x86/thinkpad_acpi.c
> @@ -6537,8 +6537,11 @@ static int volume_set_mute_ec(const bool
>  	n = (mute) ? s | TP_EC_AUDIO_MUTESW_MSK :
>  		     s & ~TP_EC_AUDIO_MUTESW_MSK;
>  
> -	if (n != s)
> +	if (n != s) {
>  		rc = volume_set_status_ec(n);
> +		if (!rc)
> +			rc = 1;
> +	}
>  
>  unlock:
>  	mutex_unlock(&volume_mutex);
> @@ -6569,8 +6572,11 @@ static int volume_set_volume_ec(const u8
>  
>  	n = (s & ~TP_EC_AUDIO_LVL_MSK) | vol;
>  
> -	if (n != s)
> +	if (n != s) {
>  		rc = volume_set_status_ec(n);
> +		if (!rc)
> +			rc = 1;
> +	}
>  
>  unlock:
>  	mutex_unlock(&volume_mutex);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
