Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYFLVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYFLVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYFLVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:09:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYFLVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:09:48 -0400
Message-ID: <48519077.2050402@zytor.com>
Date: Thu, 12 Jun 2008 14:09:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Paul Jackson <pj@sgi.com>, Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       bwalle@suse.de, hannes@saeurebad.de, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ...
 on x86_64
References: <20080612050609.88a8cf7f.pj@sgi.com>	 <86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>	 <20080612111943.c140c4cb.pj@sgi.com>	 <86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>	 <20080612151032.5a59309b.pj@sgi.com> <86802c440806121329s54bb1e6dobaaa15c26e7dc81c@mail.gmail.com>
In-Reply-To: <86802c440806121329s54bb1e6dobaaa15c26e7dc81c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> please check that commit that increase the range to 1M.
> it seems at that time, andi and peter had different idea, because
> increase 1M could waste K bytes memory.
> 
> also wonder if EFI is there, we still need to ebda?
> 

You're not actually suggesting we should throw away this memory, are 
you?  Reserving it all early is fine, but the memory unused should 
eventually be reclaimed.

It's probably safer to reserve the EBDA even with EFI; it's only a page 
or so so it doesn't matter much.

	-hpa
