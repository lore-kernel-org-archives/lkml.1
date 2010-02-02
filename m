Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0BBBzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:55:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab0BBBzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:55:37 -0500
Date: Mon, 1 Feb 2010 17:55:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] Generic page_is_ram: use __weak
Message-Id: <20100201175506.5a0b01c1.akpm@linux-foundation.org>
In-Reply-To: <4B6781D3.6090904@zytor.com>
References: <tip-e52730071567ec5b6f57e21d6693b112e01e1d0e@git.kernel.org>
	<20100201172423.6803e898.akpm@linux-foundation.org>
	<4B6781D3.6090904@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Feb 2010 17:37:23 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/01/2010 05:24 PM, Andrew Morton wrote:
> >>
> >> diff --git a/kernel/resource.c b/kernel/resource.c
> >> index b4d637a..e68cd74 100644
> >> --- a/kernel/resource.c
> >> +++ b/kernel/resource.c
> >> @@ -305,7 +305,7 @@ static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
> >>   * This generic page_is_ram() returns true if specified address is
> >>   * registered as "System RAM" in iomem_resource list.
> >>   */
> >> -int __attribute__((weak)) page_is_ram(unsigned long pfn)
> >> +int __weak page_is_ram(unsigned long pfn)
> >>  {
> >>  	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
> >>  }
> > 
> > hm, it's strange to do this as two separate commits?
> > 
> 
> You had it as a separate fix patch, and I generally don't want to fold
> patches which have different authorship, especially if the original code
> doesn't actually break anything.

Nobody's complained so far:

y:/usr/src/git26> git log | grep '\[.*@.*:' | wc -l
2434

It's a tradeoff between being nice to authors versus tree-cleanliness
and bisectability.

