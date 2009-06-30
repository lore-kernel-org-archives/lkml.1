Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZF3OOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZF3OOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZF3OOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:14:00 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46589 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbZF3ON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:13:59 -0400
Date: Tue, 30 Jun 2009 10:13:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
In-Reply-To: <20090630150035.A738.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0906301011210.6124@gentwo.org>
References: <20090630150035.A738.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, KOSAKI Motohiro wrote:

> +static void account_kernel_stack(struct thread_info *ti, int on)

static inline?

> +{
> +	struct zone* zone = page_zone(virt_to_page(ti));
> +	int sign = on ? 1 : -1;
> +	long acct = sign * (THREAD_SIZE / PAGE_SIZE);

int pages = THREAD_SIZE / PAGE_SIZE;

?

> +
> +	mod_zone_page_state(zone, NR_KERNEL_STACK, acct);

mod_zone_page_state(zone, NR_KERNEL_STACK, on ? pages : -pages);


