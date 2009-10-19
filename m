Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZJSPOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZJSPOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZJSPN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:13:59 -0400
Received: from lucidpixels.com ([75.144.35.66]:52932 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbZJSPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:13:59 -0400
Date: Mon, 19 Oct 2009 11:14:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: nut-upsuser@lists.alioth.debian.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <Pine.LNX.4.44L0.0910191100050.3899-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.0910191112380.7710@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910191100050.3899-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Oct 2009, Alan Stern wrote:

> On Sun, 18 Oct 2009, Justin Piszcz wrote:
>
>> Thanks Alan,
>>
>> I have performed all of the steps you recommended, there is also a bug in
>> the docs, the directory seems to be different, or at least if you have
>> everything compiled into the kernel and not using modules.
>
>> Start nut:
>> # /etc/init.d/nut start
>> Starting Network UPS Tools: upsdrvctl upsd upsmon.
>>
>> Within ~20-30 seconds it already broke:
>> ============================================================================
>> Broadcast Message from nut@p34.internal.lan
>>          (somewhere) at 17:22 ...
>
> Well, the usbmon trace shows that wherever the problem lies, it isn't
> in the kernel.  There were a few problems in the device itself -- it
> was queried for a report and did not provide any data.  The nut program
> should be smart enough to retry when this happens, but it didn't.
>
> It did try to re-establish communcation with the device, but it appears
> that nut got caught in a loop during this attempt.  During this loop
> nut did nothing but transfer a bunch of string descriptors from the
> device, over and over again at 2-second intervals.  The loop lasted for
> almost a minute, until another device error occurred.  Then nut
> recovered properly -- until a third error happened and nut got stuck in
> its loop again.
>
> Alan Stern
>

Hi,

To the nut list, the last time nut changed was 2009-06-13:

2009-06-13 04:29:25 configure nut-cgi 2.4.1-3 2.4.1-3
2009-06-13 04:29:25 status unpacked nut-cgi 2.4.1-3
2009-06-13 04:29:25 status unpacked nut-cgi 2.4.1-3
2009-06-13 04:29:25 status unpacked nut-cgi 2.4.1-3
2009-06-13 04:29:25 status unpacked nut-cgi 2.4.1-3
2009-06-13 04:29:25 status unpacked nut-cgi 2.4.1-3
2009-06-13 04:29:25 status half-configured nut-cgi 2.4.1-3
2009-06-13 04:29:26 status installed nut-cgi 2.4.1-3

I made no changes to the nut configuration or install.

What did change was the motherboard.

From: Intel DG965WH -> Intel DP55KG

Then this problem began.

Justin.

