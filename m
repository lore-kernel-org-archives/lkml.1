Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYLGD20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYLGD20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 22:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYLGD2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 22:28:19 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58448 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbYLGD2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 22:28:18 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=CTgm8HW5NdcI4lobA3sA:9 a=sLjDbQTWZoZoaCXqOXxtMVciFjEA:4 a=eIAGP7Fk3jIA:10 a=21q54A0nAXQA:10
Message-ID: <493B42D1.7090600@shaw.ca>
Date: Sat, 06 Dec 2008 21:28:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
References: <200812061316.38460.elendil@planet.nl> <200812061536.47894.elendil@planet.nl> <493AE8B3.7090000@shaw.ca> <tkrat.fd592eed61e41b8f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.fd592eed61e41b8f@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Robert Hancock wrote:
>> If free_irq and 
>> request_irq fix anything, then that indicates that the ohci1394 device 
>> is generating interrupts at some point during resume,
> ...
>> Likely the driver should be setting some register on the device to 
>> disable it from generating interrupts before suspend and it's not doing 
>> this.
> 
> 	reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
> 
> in ohci1394's .suspend() switches interrupts off.

Presumably it should.. but the fact remains that if free_irq helps 
anything, then the device must be generating interrupts for some reason, 
and it's really just papering over the problem. Perhaps a quirk of that 
particular chip? Something to do with the state it's in after resume?
