Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbZAZAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbZAZAOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 19:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZAZAOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 19:14:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:56118 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZAZAOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 19:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aBHq8W8vWTwwX4ZlVhmz0GjrtF0LAKQ2TbwQAhjJz9wbJQWvinxzoLMjlpuaRGjs1L
         R1FlHtDHXqnaP4/FQGR93/3X59Zi49TcycwSFtP/xaJfEuEc7/XkFiVQJw73gSMt9y5c
         9aK9sDfQF+GJSNob9eO6Tuo+rAj2GVda3SVxQ=
Date: Mon, 26 Jan 2009 03:13:54 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC] power: add optional OTG transceiver and voltage
	regulator support to pda_power
Message-ID: <20090126001354.GA18543@zarina>
Reply-To: cbouatmailru@gmail.com
References: <1232296827-16471-1-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1232296827-16471-1-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 05:40:27PM +0100, Philipp Zabel wrote:
> This patch allows machines to use an OTG transceiver driver instead of
> supplying a custom is_usb_online callback to check USB power.
> Also, in the case that the OTG transceiver handles charger control when
> connected to USB, a regulator named "ac_draw" can be supplied instead of
> the custom set_charge callback to control the charger when connected to AC.
> 
> The check for (transceiver->state == OTG_STATE_B_PERIPHERAL) in
> otg_is_usb_online is probably too simple, I'm just using this with a peripheral
> only device and gpio_vbus + bq24022. I'm not sure which other OTG states
> can supply power.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---

I'm not USB OTG expert, but from the power supply point of view the
patch looks OK. If there are no objections, I'll queue it for 2.6.30.

Thanks Philipp. ;-)

[...]
> +#ifdef CONFIG_USB_OTG_UTILS
> +	transceiver = otg_get_transceiver();
> +	if (transceiver && !pdata->is_usb_online) {
> +		pdata->is_usb_online = otg_is_usb_online;
> +	}
> +#endif

On a general note, I'd prefer linux/usb/otg.h provide stubs for
!USB_OTG_UTILS case.. I.e.

#ifdef CONFIG_USB_OTG_UTILS
extern struct otg_transceiver *otg_get_transceiver(void);
extern void otg_put_transceiver(struct otg_transceiver *);
#else
static inline struct otg_transceiver *otg_get_transceiver(void)
{ return NULL; }
static inline void otg_put_transceiver(struct otg_transceiver *) {}
#endif

That way we could avoid #ifdefs in drivers.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
