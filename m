Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYLGS5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYLGS5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYLGS5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:57:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7310 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYLGS5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:57:19 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=YgUFFZ79AAAA:8 a=-kRHijCJ5Q3qL_3XY7cA:9 a=q0g5g2MXn4dlLtandWxHQR6JrXYA:4 a=eIAGP7Fk3jIA:10 a=21q54A0nAXQA:10
Message-ID: <493C1C8F.5070003@shaw.ca>
Date: Sun, 07 Dec 2008 12:57:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
References: <200812061316.38460.elendil@planet.nl> <200812061536.47894.elendil@planet.nl> <493AE8B3.7090000@shaw.ca> <tkrat.fd592eed61e41b8f@s5r6.in-berlin.de> <493B42D1.7090600@shaw.ca> <493B953F.3070504@s5r6.in-berlin.de>
In-Reply-To: <493B953F.3070504@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Robert Hancock wrote:
>> Stefan Richter wrote:
>>>     reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
>>>
>>> in ohci1394's .suspend() switches interrupts off.
>> Presumably it should.. but the fact remains that if free_irq helps
>> anything, then the device must be generating interrupts for some reason,
> 
> Or another device:
> http://www.gossamer-threads.com/lists/linux/kernel/896053
> 
> Questions for Frans, quoting tglx:
> Do you have CONFIG_NET_POLL_CONTROLLER enabled in your .config?  If yes,
> can you please disable it and check whether the problem persists?

Hmm, that case sounds like disable_irq on an MSI device redirecting the 
interrupts to the legacy INTx interrupt instead of actually disabling 
them? If this is what's happening here, then that's the bug..
