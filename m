Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbXCZUac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbXCZUac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbXCZUac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:30:32 -0400
Received: from outmx012.isp.belgacom.be ([195.238.5.70]:59987 "EHLO
	outmx012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXCZUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:30:31 -0400
Date: Mon, 26 Mar 2007 22:30:17 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Semi-typical watchdog bug re early misc_register()
Message-ID: <20070326203017.GA4014@infomag.infomag.iguana.be>
References: <20070324125811.GA30017@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324125811.GA30017@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

> It seems that some watchdog drivers are doing following mistake:
> 
> 	rv = misc_register();
> 	if (rv < 0)
> 		return rv;
> 	rv = request_region();
> 	if (rv < 0) {
> 		misc_deregister();
> 		return rv;
> 	}
> 
> But, right after misc_register() returns, misc device can be opened and
> ioctls interacting with hardware issued, and driver can do outb() to
> port it doesn't own yet, because request_region() is still pending.

Totally agree. patch has been added to linux-2.6-watchdog-mm tree.

> Also, is there similar ordering between register_reboot_notifier() and
> misc_register() ? Some drivers do misc_register() last, some register
> reboot notifiers.

I prefer that the reboot notifiers are loaded before you give userspace the
ability to communicate with the driver.

Greetings,
Wim.

