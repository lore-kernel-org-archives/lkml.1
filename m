Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbYFBN6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbYFBN6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbYFBN6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:58:24 -0400
Received: from saeurebad.de ([85.214.36.134]:58244 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655AbYFBN6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:58:23 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 08/14] bootmem: clean up alloc_bootmem_core
References: <20080530194220.286976884@saeurebad.de>
	<20080530194738.789921715@saeurebad.de>
	<20080602210058.B2E2.E1E9C6FF@jp.fujitsu.com>
Date: Mon, 02 Jun 2008 15:57:44 +0200
In-Reply-To: <20080602210058.B2E2.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Mon, 02 Jun 2008 21:34:02 +0900")
Message-ID: <87hcccrlbb.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> Hello.
>
>> +		/*
>> +		 * Reserve the area now:
>> +		 */
>> +		for (i = PFN_DOWN(new_start) + merge; i < PFN_UP(new_end); i++)
>> +			if (test_and_set_bit(i, bdata->node_bootmem_map))
>> +				BUG();
>> +
>> +		region = phys_to_virt(bdata->node_boot_start + new_start);
>> +		memset(region, 0, size);
>> +		return region;
>
> bdata->last_success doesn't seem to be updated in alloc_bootmem_core(),
> it is updated in only __free().
> Is it intended? If not, it should be updated, I suppose....

Yeah, I forgot that.  See my reply to `bootmem: respect goal more
likely'.

Thanks for reviewing!

	Hannes
