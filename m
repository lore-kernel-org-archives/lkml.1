Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbZBXOlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbZBXOlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZBXOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:41:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:48649 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbZBXOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:41:14 -0500
Message-ID: <49A406EB.8080509@kernel.org>
Date: Tue, 24 Feb 2009 23:40:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224130212.GC31295@elte.hu>
In-Reply-To: <20090224130212.GC31295@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 14:40:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>>> and i think that abstraction is wrong.
>> No, it's not wrong.  It simply is irrelevant - it's congruent 
>> vs. contiguos and all that we need is congruent.  Contiguous 
>> of course achieves congruent but it doesn't make any 
>> difference for this purpose.
> 
> Well, as long as we can go up in unit size to 2MB (on 64-bit 
> x86) i'm fine with that model.

Yeap, it defintely can.

> There's no granularity artifacts, right? pcpu_populate_chunk() 
> intelligently only populates pages on an as-needed basis, so 
> extending the percpu areas with a 2MB unit does not trigger 
> nr_cpus*2MB allocations straight away.

Yeap, it doesn't although reclamation is done per-chunk currently.

> The code looks very clean and if we can agree on the SMP/NUMA 
> symmetry and the dynamic-ptr optimizations that it allows, plus 
> if you can up the unit size to 2MB on 64-bit x86, i'm a happy 
> camper and will pull it.

Sounds good.  Thanks.

-- 
tejun
