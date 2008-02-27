Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYB0FUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYB0FUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYB0FU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:20:27 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYB0FU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:20:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=Fwl8Sm8cjJvxNtPuXnNF39RZ/BTGnNzOR/pW5kXjCH9Cks4Oi90OT2274T750I8sy
	ytP3pRUYOnA1+VveLv2HQ==
Date: Tue, 26 Feb 2008 21:19:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
In-Reply-To: <47C4EF2D.90508@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.00.0802262115270.1799@chino.kir.corp.google.com>
References: <20080227133850.4249.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080227140042.66abb805.kamezawa.hiroyu@jp.fujitsu.com> <20080227140221.424C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <47C4EF2D.90508@linux.vnet.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Balbir Singh wrote:

> >> CONFIG_SIMULTANEOUS_PAGE_RECLAIMERS 
> >> int
> >> default 3
> >> depends on DEBUG
> >> help
> >>   This value determines the number of threads which can do page reclaim
> >>   in a zone simultaneously. If this is too big, performance under heavy memory
> >>   pressure will decrease.
> >>   If unsure, use default.
> >> ==
> >>
> >> Then, you can get performance reports from people interested in this
> >> feature in test cycle.
> > 
> > hm, intersting.
> > but sysctl parameter is more better, i think.
> > 
> > OK, I'll add it at next post.
> 
> I think sysctl should be interesting. The config option provides good
> documentation, but it is static in nature (requires reboot to change). I wish we
> could have the best of both worlds.
> 

I disagree, the config option is indeed static but so is the NUMA topology 
of the machine.  It represents the maximum number of page reclaim threads 
that should be allowed for that specific topology; a maximum should not 
need to be redefined with yet another sysctl and should remain independent 
of various workloads.

However, I would recommend adding the word "MAX" to the config option.

		David
