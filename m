Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbZCPMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbZCPMsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZCPMsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:48:10 -0400
Received: from kotten8a.marieberg.ac ([213.238.238.22]:41316 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750997AbZCPMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:48:10 -0400
Date: Mon, 16 Mar 2009 13:48:02 +0100 (CET)
From: Ralf Nyren <ralf@nyren.net>
X-X-Sender: plumbum@fujje.iml.umu.se
To: Greg KH <greg@kroah.com>
cc: Rory Filer <rfiler@SierraWireless.com>,
       Stephen Clark <sclark46@earthlink.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
In-Reply-To: <20090316043359.GA24632@kroah.com>
Message-ID: <alpine.DEB.1.10.0903161324440.32709@fujje.iml.umu.se>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com> <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se> <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net> <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se>
 <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local> <20090316043359.GA24632@kroah.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rory,

I have tried changing OBUFSIZE in ppp_async.c (still kernel 2.6.28.7), first
512 and then 4096. However the speed "limit" of about 100KB/s remains the same.
So perhaps there's some setup/firmware issue with the hardware. If I understand
things correctly the Windows driver uses a proprietary protocol to init the card
while in Linux you use the AT command interface. Could be something there which
makes a difference I guess.

Best regards, Ralf

On Sun, 15 Mar 2009, Greg KH wrote:

> On Sun, Mar 15, 2009 at 03:30:54PM -0700, Rory Filer wrote:
>> Hi Ralf
>>
>> Using the driver we sent you on a call-box (i.e. with a "perfect"
>> simulated network connection) on Ubuntu 8.04 we were seeing ~4 Mbps on
>> the downlink. So I would rule out any problem with the driver and
>> conclude it must be something in either PPP/Linux or in the modem. In
>> order to rule out the modem, I've got a question into one of our UMTS
>> engineers and will send you a reply when we get the answer.
>>
>> We did play around a little with 2.4 kernels of Linux and discovered
>> there is a buffer in PPP_ASYNC.C which, when its size is increased,
>> doubled the throughput. If you are savvy enough with Linux, you might
>> want to try playing with that. We stopped short of any thorough
>> testing of changing this array size, but were pleased with the result.
>> If I recall properly, the size of this array is (was, in 2.4) 256
>> bytes. Doubling it gave an immediate improvement. We were guessing
>> that the small size of this buffer was fine in the "old days" when
>> modems peaked at ~56 kbps. Even 8 years ago that was the fastest you
>> could go with a GPRS product, now our new HSPA+ products yields 21
>> Mbps on Telstra's network! Quite a difference.
>
> Ah, the OBUFSIZE #define in drivers/net/ppp_async.c?
>
> Anyone care to bump this size up and see if that helps out?
>
> thanks,
>
> greg k-h
>
