Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbYEXBRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbYEXBRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYEXBRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:17:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbYEXBRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:17:40 -0400
Date: Fri, 23 May 2008 18:17:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [RFC] Circular include dependencies
Message-Id: <20080523181728.b30409b2.akpm@linux-foundation.org>
In-Reply-To: <20080523132034.GB15384@flint.arm.linux.org.uk>
References: <20080523132034.GB15384@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 14:20:34 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> Hi,
> 
> Having discovered some circular include dependencies in the ARM header
> files which were causing build issues, I created a script to walk ARM
> includes and report any similar issues found - which includes traversing
> any referenced linux/ includes.
> 
> It identified the following two in include/linux/:
> 
>   linux/mmzone.h <- linux/memory_hotplug.h <- linux/mmzone.h
>   linux/mmzone.h <- linux/topology.h <- linux/mmzone.h
> 
> Checking them by hand reveals that these are real.  Whether they're
> capable of causing a problem or not, I'm not going to comment on.
> However, they're not a good idea and someone should probably look at
> resolving the loops.

(cc's added).

Thanks.

I'm not sure who we could tap for the topology.h one.

A suitable (and often good) way of solving this is to identify the
things which a.h needs from b.h and hoist them out into a new c.h and
include that from both a.h and b.h.

