Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZLBWOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZLBWOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbZLBWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:14:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:33502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbZLBWOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:14:51 -0500
Message-ID: <4B16E727.9070104@kernel.org>
Date: Thu, 03 Dec 2009 07:16:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       michal.simek@petalogix.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au> <4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au> <4B152D22.9070001@kernel.org> <alpine.DEB.2.00.0912010946340.8841@router.home> <20091201160119.GA10826@elte.hu> <4B15A5A6.2090200@kernel.org> <alpine.DEB.2.00.0912020853320.31731@router.home>
In-Reply-To: <alpine.DEB.2.00.0912020853320.31731@router.home>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 11:55 PM, Christoph Lameter wrote:
> On Wed, 2 Dec 2009, Tejun Heo wrote:
> 
>> This isn't usual alignment.  struct work_struct has one data fields
>> which is overloaded for two purposes.  Lower few bits are used to
>> carry flags while upper bits are used to point to sruct
>> cpu_workqueue_struct.  So, the number of available bits for flags are
>> determined by the alignment of cpu_workqueue_struct.  Memory usage for
> 
> The default mininum slab alignment in UP is 8 bytes which means you can
> use 3 bits. And as far as I can see only the lower two bits are used. You
> still have one bit leftover. (current upstream that is did not check if
> you modified it).

For colored workqueue flushing, it ends up using more than three bits.
I haven't decided it fully yet but total of six or seven depending on
how many colors are used.  So, we need forced alignment anyway.

Thanks.

-- 
tejun
