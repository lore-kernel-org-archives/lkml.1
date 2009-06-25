Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZFYCga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZFYCga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZFYCgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:36:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZFYCgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:36:20 -0400
Message-ID: <4A42E25B.6080102@kernel.org>
Date: Thu, 25 Jun 2009 11:35:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org>
In-Reply-To: <20090624165508.30b88343.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 02:35:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> On Wed, 24 Jun 2009 22:30:06 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> This patchset is available in the following git tree and will be
>> published in for-next if there's no major objection.  It might get
>> rebased before going into for-next.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git lpage-numa
> 
> <tries to read the patches>
> 
> Boy, this stuff is complicated.  Does it all work?

I sure hope so.

> The Impact: lines were useful :)

Eh.. well, it looks like it's going the way of dodo tho.

> I assume from the tremendous number of for_each_possible_cpu()s that
> CPU hotplug awareness won't be happening.
> 
> Do we have a feeling for the amount of wastage here?  If
> 
> 	num_possible_cpus() - num_online_cpus() == N
> 
> and N is large, what did it cost?
> 
> And what are reasonable values of N?

The goal is to eventually implement has_ever_been_online_cpus (any
better naming?) mask and allocate only for those cpus.  I think I
mentioned it in one of the patch descriptions but anyways the unit_map
and lpage improvments implemented in this patchset will be used for
that purpose.  The plan is to treat possible but offline cpus as if
they belong to separate group such that they don't end up sharing the
same PMD page and later when those cpus come up the generic 4k mapping
can kick in and map them.

Thanks.

-- 
tejun
