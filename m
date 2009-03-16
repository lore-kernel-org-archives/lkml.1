Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbZCPSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbZCPSSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZCPSSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:18:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:39248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZCPSSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:18:14 -0400
Message-ID: <49BE97B0.8000004@kernel.org>
Date: Mon, 16 Mar 2009 11:17:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org>
In-Reply-To: <49BE9248.6050707@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> could be max_pfn_mapped change in head_32.S that reduce mapping range
>> to _end only.
>>   
> 
> Yes, I would say you're right.  Trimming the mapping to _end only leaves
> the space under the kernel avaliable for allocating pagetable from e820
> space.  In this case we've got DEBUG_PAGEALLOC enabled, which inhibits
> the use of PSE, and BIOS corruption checking on, which eats a chunk of
> low memory.  In combination, there's only 0x8f000 bytes free below the
> kernel, and it needs 0xe1000 to allocate for pagetables.
> 
> Reverting 2bd2753ff46346543ab92e80df9d96366e21baa5 fixes the problem for
> me, though it does result in a kernel with a 73MB BSS...
> 

need more extra check for INIT_MAP_SIZE calculating...

YH



