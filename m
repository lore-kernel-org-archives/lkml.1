Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZLKRWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZLKRWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZLKRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:22:11 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33169 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZLKRWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SiZu7tLRkAoTVn2HPehbZUiSTtC4FThj0ndy6+izyKN7/AGlBNt9B2ihRa0J0X0vwW
         xpVBv/P86Eag6Rkyt4GLUc6UpON/NhDZtq9+jSS/tKmt34H7ts4PmUAylFgvWtbBJJHv
         NihIRqjYYboBuJR48x3FdStqe9dfAT63tlJR0=
MIME-Version: 1.0
In-Reply-To: <1260531086-23857-3-git-send-email-felipe.balbi@nokia.com>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
	 <1260531086-23857-3-git-send-email-felipe.balbi@nokia.com>
Date: Fri, 11 Dec 2009 22:52:14 +0530
Message-ID: <c60a9cb0912110922g10fd0cc7m3b3430731db5ed81@mail.gmail.com>
Subject: Re: [RFC/PATCH 2/5] usb: otg: twl4030: add support for notifier
From: sai pavan <saipavan.243@gmail.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> @@ -628,7 +628,8 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
>                else
>                        twl4030_phy_resume(twl);
>
> -               twl4030charger_usb_en(status == USB_LINK_VBUS);
> +               blocking_notifier_call_chain(&twl->otg.notifier, status,
> +                               twl->otg.gadget);
>        }

You might not want to invoke blocking notifier chain(may sleep) from
interrupt context. May be atomic notifier chain is appropriate here.
