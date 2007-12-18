Return-Path: <linux-kernel-owner+w=401wt.eu-S1764428AbXLRAWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764428AbXLRAWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbXLRAWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:22:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45075 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbXLRAWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:22:40 -0500
Message-ID: <476712BD.4020008@zytor.com>
Date: Mon, 17 Dec 2007 16:22:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Parag Warudkar <parag.warudkar@gmail.com>, devzero@web.de,
       Matt.Domsch@dell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
References: <49448787@web.de>	<82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com>	<20071216201849.24f7aa5f@the-village.bc.nu>	<Pine.LNX.4.64.0712180023310.32270@fbirervta.pbzchgretzou.qr> <20071218001007.2324dbfc@the-village.bc.nu>
In-Reply-To: <20071218001007.2324dbfc@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Does printk support escape sequences? The last time I tried
>> printk("\e[1;35m omg ponies \e[0m"); that did not went too successful.
> 
> It should handle \r correctly. If not that is easy to fix.
> 
> Escape codes are bad and should not be used - you may have a serial
> console and not be on a Linux console

It's not printk(), or the console, that's the issue...
Consider logging to a file, which is quite common.

Dumping formatting characters in there is a bit evil.

Instead of using \r and overwrite, something like

Testing foo... ok

printk(KERN_INFO "Testing foo... ");
foo();
printk("ok\n");

... really is a lot better.  We used to do that a lot more.

	-hpa
