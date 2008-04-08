Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbYDHIFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbYDHIFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYDHIFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:05:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbYDHIFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:05:04 -0400
Date: Tue, 8 Apr 2008 10:04:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
Message-ID: <20080408080446.GA12308@elte.hu>
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqytqwl7.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > hm, bootmem allocator is supposed to clear memory. We have a couple 
> > of places that rely on that.
> 
> I was actually considering to change that for the GB pages hugetlbfs 
> patchkit, because memset for 1G is a little slow and not needed (will 
> be cleared later anyways) and it might be a problem for very large 
> systems with a lot of such pages at boot.

changing the default behavior of bootmem alloc to be non-clearing is a 
really bad idea that will only cause unrobustness. The proper approach 
is to add an _opt-in_ API that does not clear memory 
(bootmem_alloc_dontclear() or whatever), available to callers that know 
it for sure that they dont need the clearing.

	Ingo
