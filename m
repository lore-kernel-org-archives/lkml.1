Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZDPRVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZDPRVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbZDPRUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:20:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:42842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbZDPRUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:20:53 -0400
Message-ID: <49E76864.9060309@kernel.org>
Date: Thu, 16 Apr 2009 10:18:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
References: <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu>
In-Reply-To: <20090416165640.GA13927@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Thu, 16 Apr 2009, Jesse Barnes wrote:
>>> Any comments on this one, Linus?  Should I include your ack?
>> I'm not ready to ack it, no. I don't think the suggested patch is very 
>> clean or necessarily sensible as-is. It seems very ad-hoc. 
>>
>> I was literally thinking of something like 
>>  "round up from the last RAM by X"
>>  "round up from the last reserved region by Y"
>>  "pick the bigger of the two"
>>
>> with helper functions for the two cases and comments along the 
>> lines of why we do it. Something that was a bit more obvious about 
>> what it's doing and why.
> 
> That's sensible - but i'd also like to inject hpa's add-on idea: if 
> we do that then we should do it _explicitly_ and _visibly_, by 
> injecting an artificial e820 reservation range to all expected 
> "vulnerable" holes we cannot fully trust.
> 
> We'd do that after all the fixed resources are allocated, but before 
> dynamic PCI allocations.
> 
> That prevents the PCI layer from dynamically allocating anything 
> into that protective zone, and documents it as well (and makes it 
> visible in boot logs, etc.) - instead of just a silent rule 
> somewhere that no-one will really see if it breaks.

that need to do done much earlier, and much simple, just need to make that range to be reserved in e820.
and later e820_setup_gap even don't need to be aligned again.

YH
