Return-Path: <linux-kernel-owner+w=401wt.eu-S1750723AbXAZKgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750723AbXAZKgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXAZKgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:36:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55230 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbXAZKgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:36:17 -0500
Date: Fri, 26 Jan 2007 02:29:55 -0800
From: Andrew Morton <akpm@osdl.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>, aubreylee@gmail.com,
       svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       rgetz@blackfin.uclinux.org, Michael.Hennerich@analog.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Message-Id: <20070126022955.f9b6b11f.akpm@osdl.org>
In-Reply-To: <20070124141510.7775829c.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
	<20070124121318.6874f003.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0701232028520.6820@schroedinger.engr.sgi.com>
	<20070124141510.7775829c.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 14:15:10 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> - One for stability
>   When a customer constructs their detabase(Oracle), the system often goes to oom.
>   This is because that the system cannot allocate DMA_ZOME memory for 32bit device.
>   (USB or e100)
>   Not allowing to use almost all pages as page cache (for temporal use) will be some help.
>   (Note: construction DB on ext3....so all writes are serialized and the system couldn't
>    free page cache.)

I'm surprised that any reasonable driver has a dependency on ZONE_DMA.  Are
you sure?  Send full oom-killer output, please.


> - One for tuing.
>   Sometimes our cutomer requests us to limit size of page-cache.
>   
>   Many cutomers's memory usage reaches 99.x%. (this is very common situation.)
>   If almost all memories are used by page-cache, and we can think we can free it.
>   But the customer cannot estimate what amount of page-cache can be freed (without 
>   perfromance regression).
>   
>   When a cutomer wants to add a new application, he tunes the system.
>   But memory usage is always 99%.
>   page-cache limitation is useful when the customer tunes his system and find
>   sets of data and page-cache. 
>   (Of course, we can use some other complicated resource management system for this.)
>   This will allow the users to decide that they need extra memory or not.
> 
>   And...some customers want to keep memory Free as much as possible.
>   99% memory usage makes insecure them ;)

Tell them to do "echo 3 > /proc/sys/vm/drop_caches", then wait three minutes?
