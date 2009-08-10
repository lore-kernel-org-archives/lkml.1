Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZHJQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZHJQjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZHJQjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:39:52 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:57507 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbZHJQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:39:52 -0400
Message-ID: <4A804D67.4080308@gefanuc.com>
Date: Mon, 10 Aug 2009 17:40:07 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <20090810153127.GB23319@braap.org>
In-Reply-To: <20090810153127.GB23319@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Emilio G. Cota wrote:
>   
>> I've had a closer look; it seems to me that most of it is unnecessary;
>> there's no show those lists to a driver. I'd just provide a single
>> 'do_dma(attributes)' call that sleeps until it's done (or similar).
>>     
>
> s/there's no show/there's no point in showing/
>
> Basically the driver simply shouldn't care about these DMA
> lists. It just wants to get the work done, no matter how.
>
> E.
>   
I have provided helper functions to aid with filling out structures that 
define the attributes, these are then pointed to by a generic DMA 
transfer structure. Bar the helper functions to aid in completing these 
commonly filled structures, at this level I can't see much difference. 
However rather than targeting a the "single shot" operation of the DMA 
controller I have provided the ability for the driver writer to use the 
link-list mode.

If the driver writer wants a "single shot" effect, there's little 
overhead in creating a one item link-list and executing it. However, 
without support for this mode the author is stuck with single shot 
transfers.  If the author wants to perform scatter gather type 
transfers, without this functionality in the API - which is supported by 
all the bridges I have seen - he won't be able to easily avail himself 
of this functionality and get "work done".

Martyn

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
