Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZCEW6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZCEW6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZCEW6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:58:00 -0500
Received: from gw.goop.org ([64.81.55.164]:41697 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZCEW57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:57:59 -0500
Message-ID: <49B058F0.3010405@goop.org>
Date: Thu, 05 Mar 2009 14:57:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: clean up use of system_state in virt_addr_valid
 and co
References: <49AF35B0.2000302@goop.org> <49B04CBE.9080308@gmail.com>
In-Reply-To: <49B04CBE.9080308@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 5.3.2009 03:15, Jeremy Fitzhardinge wrote:
>> x86-32: use specific __vmalloc_start_set flag in __virt_addr_valid
>> x86-64: pre-initialize boot_cpu_data.x86_phys_bits to avoid system_state
>> tests
>
> Looks good, thanks. Just an idea, wouldn't make sense to add the check 
> directly into is_vmalloc_addr?

I thought about it, but I think its simply invalid to call 
is_vmalloc_addr() until you can meaningfully have vmalloc addresses.  It 
would be nice to have some way to warn about callers who are using these 
predicates in a meaningless way, but there doesn't appear to be any 
sensible way to do so (I guess the case I'm concerned about is people 
using VMALLOC_START for something before it is meaningful).

    J
