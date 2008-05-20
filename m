Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbYETJzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbYETJzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761918AbYETJxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:21961 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764117AbYETJxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=k5lCjMdZGJCDDUZGY9HM+giGUDdMltCg36DDLqavik0aqXt6xVrEjVJ7gSmHxru3l2gee/rPGpXYbA5xUw7ElKhh4bFBVcjCGiZ7tZniVKGqfs1WQvQaBE7JmlkWQZS7znZ5K7F3IvWgODqDYduf/oVWHiiwUuFb9iUpBo90bh0=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 09/15] rfkill: add the WWAN radio type
Date: Tue, 20 May 2008 12:08:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       =?utf-8?q?I=C3=B1aky_P=C3=A9rez-Gonz=C3=A1lez?= 
	<inaky.perez-gonzalez@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-10-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-10-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805201208.53740.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> specific type (WiMAX) was added.  That's useless for other WWAN devices,
> such as EDGE, UMTS, X-RTT and other such radios.
> 
> Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> as most devices really want to use KEY_WLAN for WWAN control (in a cycle of
> none, WLAN, WWAN, WLAN+WWAN) and need no specific keycode added.
>
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

If WiMAX is a subset of the WWAN technology, shouldn't we replace WiMAX completely
in rfkill? Otherwise people might get ideas and add the other technologies seperately as well. ;)

Other then that, the addition of WWAN is fine with me. :)

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Cc: Iñaky Pérez-González <inaky.perez-gonzalez@intel.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  include/linux/rfkill.h    |    2 ++
>  net/rfkill/rfkill-input.c |    4 ++++
>  net/rfkill/rfkill.c       |    3 +++
>  3 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 844e961..c0cab7d 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -34,12 +34,14 @@
>   * RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
>   * RFKILL_TYPE_UWB: switch is on a ultra wideband device.
>   * RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
> + * RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
>   */
>  enum rfkill_type {
>  	RFKILL_TYPE_WLAN ,
>  	RFKILL_TYPE_BLUETOOTH,
>  	RFKILL_TYPE_UWB,
>  	RFKILL_TYPE_WIMAX,
> +	RFKILL_TYPE_WWAN,
>  	RFKILL_TYPE_MAX,
>  };
>  
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 9d6c925..29c13d3 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -101,6 +101,7 @@ static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
>  static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
>  static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
>  static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
> +static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
>  
>  static void rfkill_event(struct input_handle *handle, unsigned int type,
>  			unsigned int code, int data)
> @@ -126,6 +127,9 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
>  		switch (code) {
>  		case SW_RFKILL_ALL:
>  			/* EVERY radio type. data != 0 means radios ON */
> +			rfkill_schedule_set(&rfkill_wwan,
> +					    (data)? RFKILL_STATE_ON:
> +						    RFKILL_STATE_OFF);
>  			rfkill_schedule_set(&rfkill_wimax,
>  					    (data)? RFKILL_STATE_ON:
>  						    RFKILL_STATE_OFF);
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 2e19b68..c5a79ab 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -176,6 +176,9 @@ static ssize_t rfkill_type_show(struct device *dev,
>  	case RFKILL_TYPE_WIMAX:
>  		type = "wimax";
>  		break;
> +	case RFKILL_TYPE_WWAN:
> +		type = "wwan";
> +		break;
>  	default:
>  		BUG();
>  	}


