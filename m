Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZD2V5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZD2V5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbZD2V44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:56:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:39844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654AbZD2V44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:56:56 -0400
Message-ID: <49F8CCC4.8040903@kernel.org>
Date: Wed, 29 Apr 2009 14:55:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: using move_irq_desc
References: <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu> <49F753DF.6040104@kernel.org> <20090429120056.GE11586@elte.hu> <49F87FF3.1090600@kernel.org> <20090429204135.GF21421@elte.hu> <20090429212317.GA30147@elte.hu>
In-Reply-To: <20090429212317.GA30147@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> move_irq_desc will try to move irq_desc to node wanted if allocated one is not correct.
>>> (happen on device on different nodes that are using MSI, drivers are loaded and unloaded
>>> randomly)
>>>
>>> [ Impact: make irq_desc go with device on node ]
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> ---
>>>  arch/x86/kernel/apic/io_apic.c |    6 +-----
>>>  include/linux/irq.h            |    4 ++++
>>>  2 files changed, 5 insertions(+), 5 deletions(-)
>> applied, thanks. I'll look into merging it into the irq tree 
>> tomorrow and testing it.
> 
> gave it a brief try and got:
> 
> kernel/irq/numa_migrate.c: In function ‘init_copy_one_irq_desc’:
> kernel/irq/numa_migrate.c:46: error: ‘struct irq_desc’ has no member named ‘node’
> kernel/irq/numa_migrate.c: In function ‘move_irq_desc’:
> kernel/irq/numa_migrate.c:114: error: ‘struct irq_desc’ has no member named ‘node’
> kernel/irq/numa_migrate.c:114: error: ‘struct irq_desc’ has no member named ‘node’
> kernel/irq/numa_migrate.c:114: error: ‘struct irq_desc’ has no member named ‘node’
> 

.config?

YH
