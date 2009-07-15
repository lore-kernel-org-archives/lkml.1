Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZGOWXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZGOWXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZGOWXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:23:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZGOWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:23:33 -0400
Date: Thu, 16 Jul 2009 00:23:29 +0200
From: Karsten Keil <keil@b1-systems.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Matthias Urlichs <matthias@urlichs.de>, isdn@linux-pingi.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: drivers/isdn/hardware/mISDN/hfcpci.c compiler warning seems
	like a BUG
Message-ID: <20090715222329.GA5292@nb-hp>
References: <1247639997.2437.21.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1247639997.2437.21.camel@ht.satnam>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Provags-ID: V01U2FsdGVkX18fusPva0R3H+gwhjp76jfHZrITRrXkjEiwTZ5
 oxt12QNUbHFms0kyacyoccO6fxZyG4v7fEL3MB+q51QuRs6UfX
 93MWxMeFfI0Fn/TW701y+lEZZi3IV03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:09:57PM +0530, Jaswinder Singh Rajput wrote:
> I am getting this compiler warning in linus tree :
> 
>   CC [M]  drivers/isdn/hardware/mISDN/hfcpci.o
> drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
> drivers/isdn/hardware/mISDN/hfcpci.c:2333: warning: ignoring return value of ‘driver_for_each_device’, declared with attribute warn_unused_result
> 
> static void
> hfcpci_softirq(void *arg)
> {
>         (void) driver_for_each_device(&hfc_driver.driver, NULL, arg,
>                                         _hfcpci_softirq);
> 
>         /* if next event would be in the past ... */
>         if ((s32)(hfc_jiffies + tics - jiffies) <= 0)
>                 hfc_jiffies = jiffies + 1;
>         else
>                 hfc_jiffies += tics;
>         hfc_tl.expires = hfc_jiffies;
>         add_timer(&hfc_tl);
> }
> 
> It seems to me it should return is driver_for_each_device fails :
>         if (driver_for_each_device(&hfc_driver.driver, NULL, arg,
>                                    _hfcpci_softirq))
> 		return;

Without looking deeper into it (I'm on a trip with limited net access), this sounds 
resonable for me, I will have a closer look next week.

> 
> or if possible can we return this error code for hfcpci_softirq()
> 
> Thanks,
> --
> JSR
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
