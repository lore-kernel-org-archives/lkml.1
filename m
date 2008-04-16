Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYDPTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYDPTSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYDPTSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:18:23 -0400
Received: from saeurebad.de ([85.214.36.134]:42233 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYDPTSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:18:23 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux MM <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC][patch 2/5] mm: Node-setup agnostic free_bootmem()
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
	<20080416113719.092060936@skyscraper.fehenstaub.lan>
	<86802c440804161054h6f0cfc3dmde49006afb7889b2@mail.gmail.com>
	<86802c440804161144id4f2a68i37513ac0428c693@mail.gmail.com>
	<20080416184816.GA4400@elte.hu>
Date: Wed, 16 Apr 2008 21:17:58 +0200
In-Reply-To: <20080416184816.GA4400@elte.hu> (Ingo Molnar's message of "Wed,
	16 Apr 2008 20:48:16 +0200")
Message-ID: <877iexfw2h.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> >  Yes, it should work well with cross nodes case.
>> >
>> >  but please add boundary check on free_bootmem_node too.
>> 
>> also please note: it will have problem span nodes box.
>> 
>> for example: node 0: 0-2g, 4-6g, node1: 2-4g, 6-8g. and if ramdisk sit 
>> creoss 2G boundary. you will only free the range before 2g.
>
> yes. Such systems _will_ become more common - so the "this is rare" 
> arguments are incorrect. bootmem has to be robust enough to deal with 
> it.

Ingo, I never doubted any of this, I was just asking more than once if
and when this might happen.  And I don't want the allocator become
fragile, just not completely ignorant about bogus input.

But the situation is still not clear for me.  Ingo, how are these
node spanning pfn ranges represented in the kernel?  How many node
descriptors will you have in the case Yinghai described and how will
they look like?

	Hannes
