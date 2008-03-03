Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbYCCR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbYCCR7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbYCCR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:59:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbYCCR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:59:10 -0500
Message-ID: <47CC3C32.4000509@zytor.com>
Date: Mon, 03 Mar 2008 09:58:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, torvalds@linux-foundation.org,
       hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <29495f1d0803030951i151c6373oe1839705983795ee@mail.gmail.com> <20080303175557.GA26718@elte.hu>
In-Reply-To: <20080303175557.GA26718@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> 
>>>  in any case, the commit has to be reverted as it clearly isnt a NOP 
>>>  on your box as it was intended to be. (it should only have made a 
>>>  difference in a rare hugetlbfs case)
>> On x86/{,_64}, _PAGE_PSE and _PAGE_PROTNONE are the same bit. Would 
>> that have any effect here? We encountered that collision when adding 
>> mprotect() support for hugepages.
> 
> well, this is the PMD, and PROTNONE is a pte property.

The PSE bit in the PTE becomes the PATX bit.  It shouldn't ever be set 
in Linux.

	-hpa
