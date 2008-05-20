Return-Path: <linux-kernel-owner+w=401wt.eu-S1763868AbYETJx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763868AbYETJx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYETJxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:35703 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYETJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=bo/tRS8LTLxgyuzN3nQfrIZTBRU0bX7q8Pnn4yRPIeXXX0DA382Y9mugva0pt6QDnJHm9BhpUvf+/toIhkJLcDOpNt+HpAd2yRK5dosY48YUmlxEEgrqhmXKb29UFlUnrVhOwa9Muj4ZS2ZzBW+XiHQuWt0AJka7enRNlnptmP4=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 04/15] rfkill: clarify meaning of rfkill states
Date: Tue, 20 May 2008 12:08:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-5-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201208.35159.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> rfkill really should have been named rfswitch.  As it is, one can get
> confused whether RFKILL_STATE_ON means the KILL switch is on (and
> therefore, the radio is being *blocked* from operating), or whether it
> means the RADIO rf output is on.
> 
> Clearly state that RFKILL_STATE_ON means the radio is *unblocked* from
> operating (i.e. there is no rf killing going on).
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  Documentation/rfkill.txt |    7 +++++++
>  include/linux/rfkill.h   |    6 +++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index a83ff23..ec75d6d 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -8,6 +8,13 @@ rfkill - RF switch subsystem support
>  ===============================================================================
>  1: Implementation details
>  
> +The rfkill switch subsystem exists to add a generic interface to circuitry that
> +can enable or disable the RF output of a radio *transmitter* of any type.
> +
> +When a rfkill switch is in the RFKILL_STATE_ON, the radio transmitter is
> +*enabled*.  When the rfkill switch is in the RFKILL_STATE_OFF, the radio
> +transmitter is *disabled*.
> +
>  The rfkill switch subsystem offers support for keys often found on laptops
>  to enable wireless devices like WiFi and Bluetooth.
>  
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index e3ab21d..ca89ae1 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -44,8 +44,8 @@ enum rfkill_type {
>  };
>  
>  enum rfkill_state {
> -	RFKILL_STATE_OFF	= 0,
> -	RFKILL_STATE_ON		= 1,
> +	RFKILL_STATE_OFF	= 0,	/* Radio output blocked */
> +	RFKILL_STATE_ON		= 1,	/* Radio output active */
>  };
>  
>  /**
> @@ -53,7 +53,7 @@ enum rfkill_state {
>   * @name: Name of the switch.
>   * @type: Radio type which the button controls, the value stored
>   *	here should be a value from enum rfkill_type.
> - * @state: State of the switch (on/off).
> + * @state: State of the switch, "ON" means radio can operate.
>   * @user_claim_unsupported: Whether the hardware supports exclusive
>   *	RF-kill control by userspace. Set this before registering.
>   * @user_claim: Set when the switch is controlled exlusively by userspace.


