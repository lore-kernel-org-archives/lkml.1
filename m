Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZBWAsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZBWAsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZBWAr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:47:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:39183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZBWAr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:47:56 -0500
Message-ID: <49A1F21E.30107@kernel.org>
Date: Mon, 23 Feb 2009 09:47:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org> <20090222192748.GB21320@elte.hu>
In-Reply-To: <20090222192748.GB21320@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Feb 2009 00:47:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> Uhm, no. We'll have one extra 2MB TLB and that's it. Both the 
> low linear 2MB TLB and the high remapped alias 2MB TLB will 
> cover on average of 256 4K pages. A very good deal still.

Yeah, double the TLB usage for the specific large page.  Maybe I was
reading too many corporate emails.  :-)

> We dont want to split up the static percpu area into zillions of 
> small 4K TLBs - we'll rather use +1 large-TLB.
> 
> If we used 4K ptes we'd waste up to 512 TLB entries. (largely 
> simplified as the number of large TLB entries smaller than that 
> of 4K TLB, but still the arguments holds in terms of TLB reach.)
> 
> So there is no "TLB problem" whatsoever that i can see ...

Well, other people raised the issue and for machines with very small
separate TLBs for large pages (earlier x86s), it might be measurable
penalty.  Anyways, remap only for NUMA should suffice it seems.  I'll
post patches soon.

Thanks.

-- 
tejun
