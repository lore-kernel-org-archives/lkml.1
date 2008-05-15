Return-Path: <linux-kernel-owner+w=401wt.eu-S1765290AbYEOUm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765290AbYEOUm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYEOUmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:42:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:42563 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057AbYEOUml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:42:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,493,1204531200"; 
   d="scan'208";a="328771650"
Message-ID: <482C9F9A.5070302@intel.com>
Date: Thu, 15 May 2008 13:39:54 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Chris Peterson <cpeterso@cpeterso.com>, Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	 <20080515142154.0595e475@core>	 <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>	 <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com>	 <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com>	 <482C8D4D.3040702@garzik.org> <a24804730805151301s3c6644d0hc2c78b8008fe035d@mail.gmail.com> <482C9A0E.3020305@garzik.org>
In-Reply-To: <482C9A0E.3020305@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Chris Peterson wrote:
>> Please correct me if I'm wrong, but this thread's conclusions seem to be:
>>
>> * network interrupts are an inappropriate source of entropy (see my
>> patch)
>> * headless servers need entropy, but should seek a better solution,
>> such as EGD, hardware RNG, or other kernel entropy sources (but that
>> is a separate task)
>> * TPM RNG is a separate task and, if implemented, should be in
>> drivers/char/hw_random/
> 
> That's my own opinion, yes.  But not necessarily a consensus opinion :)

I agree it's by far the _best_ solution.

I think that some embedded devices that do not have any RNG hardware should be
able to turn off NAPI/irq mitigation and possibly fall back on IRQF_SA_RANDOM.
It's not as good as the above solution at all, but may be sufficient for headless
embedded devices that are dying for some entropy.

of course, with most of the network drivers being NAPI enabled by default this
pretty much is not realistic (as Jeff G. pointed out). Unless someone writes an
(e.g.) ethtool parameter to turn NAPI on/off :)

Auke

> 
>     Jeff
> 
> 

