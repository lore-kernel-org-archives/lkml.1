Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYFZS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYFZS5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYFZS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:57:22 -0400
Received: from saeurebad.de ([85.214.36.134]:57253 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbYFZS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:57:21 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix new alloc_bootmem_core (Re: [PATCH -mm 08/14] bootmem: clean up alloc_bootmem_core)
References: <20080605224940.434439989@saeurebad.de>
	<20080605225720.616014665@saeurebad.de>
	<20080617173021.C1FE.E1E9C6FF@jp.fujitsu.com>
Date: Thu, 26 Jun 2008 20:56:52 +0200
In-Reply-To: <20080617173021.C1FE.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Tue, 17 Jun 2008 18:34:09 +0900")
Message-ID: <87hcbg10uj.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> Hi Johannes-san.
>
> I found a bug in this patch.
>
>
>> -	eidx = end_pfn - PFN_DOWN(node_boot_start);
>> +	if (goal && goal < max)
>> +		start = ALIGN(goal, step);
>> +	else
>> +		start = ALIGN(min, step);
>
> Here should check (min < goal) too.
>
> If not, start can becomes smaller than min. and sidx doesn't point
> correct index.
> alloc_bootmem_node() almost allocates pages of other node,
> when node's min address is over MAX_DMA_ADDRESS.

Andrew, could you pull that into -mm?

	Hannes
