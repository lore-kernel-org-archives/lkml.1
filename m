Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYLJOb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYLJOb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYLJObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:31:47 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:38187 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYLJObq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:31:46 -0500
Message-ID: <493FD2D1.8040904@codefidence.com>
Date: Wed, 10 Dec 2008 16:31:45 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
Organization: Codefidence Ltd.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Laurent Pinchart <laurent.pinchart@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
References: <20081210073247.GA18630@localhost> <200812101040.09886.laurent.pinchart@skynet.be> <20081210124308.GB6772@localhost> <493FCD12.30000@codefidence.com> <20081210142301.GA11490@localhost>
In-Reply-To: <20081210142301.GA11490@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

>
>>> e.g. what if the memory is allocated from ZONE_HIGHMEM?
>>>   
>>>       
>> In many cases there is no problem to DMA high memory. If you happen to 
>> be working with a device that does have problems with full 32 bit 
>> addresses then GFP_DMA would be the right flag, not GFP_NOIO.
>>     
>
> For 64bit systems, we can easily go beyond 4GB physical memory.
> So at least we should add GFP_DMA32 in addition to GFP_NOIO?
>
>   
I don't think so. 64bit systems don't have ZONE_HIMEM - this is why I 
was referring to 32 bit.

More to the point, many devices don't have any issues accessing full 64 
bit addressing mode and many 64bit machines have IOMMU that will take 
care of those devices that DO have a problem. Adding this flag will just 
penalize the MM sub-system for no reason.  For the rare case where there 
is a device that cannot do 64 bit addressing in a 64 bit machine with no 
IOMMU, AFAIK bounce buffers are used to overcome the issue.

Cheers,
Gilad



-- 
Gilad Ben-Yossef 
Chief Coffee Drinker

Codefidence Ltd.
The code is free, your time isn't.(TM)

Web:    http://codefidence.com
Email:  gilad@codefidence.com
Office: +972-8-9316883 ext. 201
Fax:    +972-8-9316885
Mobile: +972-52-8260388

	The Doctor: Don't worry, Reinette, just a nightmare. 
	Everyone has nightmares. Even monsters from under the 
	bed have nightmares, don't you, monster?
	Reinette: What do monsters have nightmares about?
	The Doctor: Me! 

