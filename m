Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXLATC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXLATC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXLATCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:02:50 -0500
Received: from smtp-out.google.com ([216.239.33.17]:34722 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbXLATCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:02:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QZSZ4w1mQnsm3sflsU35y5GJIu8kSICA08fc2+GwfaBehzR8ZYSpnKVpmvuwWnBef
	uua1nT7Svr1Tw6j3TlnBw==
Message-ID: <6599ad830712011102h3bbfd7e6lc5c448cd8efa3158@mail.gmail.com>
Date: Sat, 1 Dec 2007 11:02:32 -0800
From: "Paul Menage" <menage@google.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: What can we do to get ready for memory controller merge in 2.6.25
Cc: balbir@linux.vnet.ibm.com, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelianov" <xemul@sw.ru>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       "Andy Whitcroft" <andyw@uk.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <20071201133652.6888a717@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474ED005.7060300@linux.vnet.ibm.com>
	 <200711301311.48291.nickpiggin@yahoo.com.au>
	 <6599ad830711302339v1f92af40v85e89484a8a6575e@mail.gmail.com>
	 <47512E65.9030803@linux.vnet.ibm.com>
	 <20071201133652.6888a717@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 1, 2007 10:36 AM, Rik van Riel <riel@redhat.com> wrote:
>
> With the /proc/refaults info, we can measure how much extra
> memory each process group needs, if any.

What's the status of that? It looks as though it would be better than
the "accessed in the last N seconds" metric that we've been playing
with, although it's possibly more intrusive?

Would it be practical to keep a non-resident set for each cgroup?

>
> As for how much memory a process group needs, at pageout time
> we can check the fraction of pages that are accessed.  If 60%
> of the pages were recently accessed at pageout time and this
> process group is spending little or no time waiting for refaults,
> 40% of the pages are *not* recently accessed and we can probably
> reduce the amount of memory assigned to this group.

It would probably be better to reduce its background-reclaim high
watermark than to reduce its limit. If you do the latter, you risk
triggering an OOM in the cgroup if it turns out that it did need all
that memory after all.

Paul
