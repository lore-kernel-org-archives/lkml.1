Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645Ab0ANGdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0ANGdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953Ab0ANGdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:33:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:26904 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0ANGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:33:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=j/fgFyQOYqYUoWVmaNXOPBwlM3CSFoSTSJj9fCtvRxbIj912cThttGyAAgSqbny7L
	RZk/sMj8tFfBYlT1ZkPDA==
Date: Wed, 13 Jan 2010 22:33:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Huang Shijie <shijie8@gmail.com>
Subject: Re: [resend][PATCH] mm: Restore zone->all_unreclaimable to independence
 word
In-Reply-To: <20100114103332.D71B.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001132229250.15428@chino.kir.corp.google.com>
References: <20100114103332.D71B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, KOSAKI Motohiro wrote:

> commit e815af95 (change all_unreclaimable zone member to flags) chage
> all_unreclaimable member to bit flag. but It have undesireble side
> effect.
> free_one_page() is one of most hot path in linux kernel and increasing
> atomic ops in it can reduce kernel performance a bit.
> 
> Thus, this patch revert such commit partially. at least
> all_unreclaimable shouldn't share memory word with other zone flags.
> 

I still think you need to quantify this; saying you don't have a large 
enough of a machine that will benefit from it isn't really a rationale for 
the lack of any data supporting your claim.  We should be basing VM 
changes on data, not on speculation that there's a measurable impact 
here.

Perhaps you could ask a colleague or another hacker to run a benchmark for 
you so that the changelog is complete?
