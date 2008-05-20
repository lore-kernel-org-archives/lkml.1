Return-Path: <linux-kernel-owner+w=401wt.eu-S1765217AbYETJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765217AbYETJ4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763992AbYETJxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:21013 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764186AbYETJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Ln6YN+ubq0r2jyWoAP48S9jK4iwr8vv5NpkfFf03UOFpzNHhVG0cqIVhYoE7EJXU3pASUZcHRKbvBDohuMpQuSwPigkQA4/cyl/xl3vahKFCYWpc+kPrhAuBI+Y/j1etUNUPG0s2/EG8kJxlrXKxIiGhBDOw/3bj7PAJBpyqRWU=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 12/15] rfkill: add type string helper
Date: Tue, 20 May 2008 12:09:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-13-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-13-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201209.02691.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> We will need access to the rfkill switch type in string format for more
> than just sysfs.  Therefore, move it to a generic helper.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill.c |   33 +++++++++++++++------------------
>  1 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 251defe..4ed8d19 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -220,34 +220,31 @@ static ssize_t rfkill_name_show(struct device *dev,
>  	return sprintf(buf, "%s\n", rfkill->name);
>  }
>  
> -static ssize_t rfkill_type_show(struct device *dev,
> -				struct device_attribute *attr,
> -				char *buf)
> +static const char const *rfkill_get_type_str(enum rfkill_type type)
>  {
> -	struct rfkill *rfkill = to_rfkill(dev);
> -	const char *type;
> -
> -	switch (rfkill->type) {
> +	switch (type) {
>  	case RFKILL_TYPE_WLAN:
> -		type = "wlan";
> -		break;
> +		return "wlan";
>  	case RFKILL_TYPE_BLUETOOTH:
> -		type = "bluetooth";
> -		break;
> +		return "bluetooth";
>  	case RFKILL_TYPE_UWB:
> -		type = "ultrawideband";
> -		break;
> +		return "ultrawideband";
>  	case RFKILL_TYPE_WIMAX:
> -		type = "wimax";
> -		break;
> +		return "wimax";
>  	case RFKILL_TYPE_WWAN:
> -		type = "wwan";
> -		break;
> +		return "wwan";
>  	default:
>  		BUG();
>  	}
> +}
> +
> +static ssize_t rfkill_type_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct rfkill *rfkill = to_rfkill(dev);
>  
> -	return sprintf(buf, "%s\n", type);
> +	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill->type));
>  }
>  
>  static ssize_t rfkill_state_show(struct device *dev,


