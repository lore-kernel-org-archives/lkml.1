Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbZFQQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbZFQQii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbZFQQia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:38:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:19787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbZFQQi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:38:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,238,1243839600"; 
   d="scan'208";a="700232592"
Message-ID: <4A391C06.2060302@intel.com>
Date: Wed, 17 Jun 2009 09:38:30 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Dragos Tatulea <dtatulea@ixiacom.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Octavian Purdila <opurdila@ixiacom.com>
Subject: Re: DMA_ENGINE: can't use it without selecting a dma engine driver
References: <20090617005318.1e35ae98@dragos-tp.localdomain>	<e9c3a7c20906162340o141d04e6n36b5b7b4a2513270@mail.gmail.com> <20090617181204.52981f5f@dragos-tp.localdomain>
In-Reply-To: <20090617181204.52981f5f@dragos-tp.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dragos Tatulea wrote:
> Hi,
> 
>>>        Just discovered that it's impossible to select the dma engine
>>> without compiling a dma engine driver from the kernel. What if I want to
>>> use a different dma engine?
>>>
>> Create a Kconfig entry for your driver in drivers/dma/Kconfig and have
>> it "select DMA_ENGINE".
> That's what I want to avoid. The dma engine driver is out of tree.
> 
> What is the rationale behind this? It seems (to me) impossible to have all
> such drivers in upstream.

It is very straightforward to have all drivers upstream, just send the 
code [1].

The rationale for this configuration scheme is to turn off a lot of 
unnecessary code when we know at build time that a dma driver will never 
be loaded.

If you must keep your driver out of tree simply maintain another out of 
tree patch that allows DMA_ENGINE to be manually enabled.

Regards,
Dan

[1]: http://www.kernel.org/doc/Documentation/SubmittingDrivers

