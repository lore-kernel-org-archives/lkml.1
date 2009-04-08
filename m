Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZDHWhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZDHWhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZDHWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:37:04 -0400
Received: from gw.goop.org ([64.81.55.164]:35885 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZDHWhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:37:02 -0400
Message-ID: <49DD270A.6060506@goop.org>
Date: Wed, 08 Apr 2009 15:36:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: galak@kernel.crashing.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
References: <7366A4DE-6848-4AF6-AA33-6BD89B0A5153@kernel.crashing.org>	<20090409061444G.fujita.tomonori@lab.ntt.co.jp>	<49DD1D6B.6030001@goop.org> <20090409071032M.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090409071032M.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> Some architectures need non-trivial bus<->phys conversion routines, etc, 
>>     
>
> Only Xen needs such conversion for swiotlb.
>   

Becky's patches of last week also added __weak annotations to 
swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev 
parameter to swiotlb_bus_to_phys; and added a weak 
swiotlb_arch_address_needs_mapping.  I assume that was needed because 
powerpc needs non-trivial implementations for those functions.

>> so either we can require it that all architectures wishing to use 
>> swiotlb define these functions, or have weak default functions that can 
>> be overridden by architectures where necessary.
>>     
>
> Can you give an example? I don't think IA64, X86_64 or POWER (which
> will use swiotlb) need any __weak functions. If you say other archs
> could use swiotlb, please tell me how they need these __weak.
>   

As I said, Becky's patches added hooks in many of the places we added 
them for Xen.  I assume that's because powerpc needs them; I have not 
seen the arch/powerpc side of those changes.

    J
