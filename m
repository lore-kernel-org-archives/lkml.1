Return-Path: <linux-kernel-owner+w=401wt.eu-S1161111AbXAZSEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161111AbXAZSEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161116AbXAZSEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:04:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44072 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111AbXAZSEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:04:09 -0500
Date: Sat, 27 Jan 2007 03:01:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Cc: clameter@sgi.com, aubreylee@gmail.com, svaidy@linux.vnet.ibm.com,
       nickpiggin@yahoo.com.au, rgetz@blackfin.uclinux.org,
       Michael.Hennerich@analog.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Message-Id: <20070127030143.3059dbb0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070126022955.f9b6b11f.akpm@osdl.org>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
	<20070124121318.6874f003.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0701232028520.6820@schroedinger.engr.sgi.com>
	<20070124141510.7775829c.kamezawa.hiroyu@jp.fujitsu.com>
	<20070126022955.f9b6b11f.akpm@osdl.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 02:29:55 -0800
Andrew Morton <akpm@osdl.org> wrote:

> On Wed, 24 Jan 2007 14:15:10 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > - One for stability
> >   When a customer constructs their detabase(Oracle), the system often goes to oom.
> >   This is because that the system cannot allocate DMA_ZOME memory for 32bit device.
> >   (USB or e100)
> >   Not allowing to use almost all pages as page cache (for temporal use) will be some help.
> >   (Note: construction DB on ext3....so all writes are serialized and the system couldn't
> >    free page cache.)
> 
> I'm surprised that any reasonable driver has a dependency on ZONE_DMA.  Are
> you sure?  Send full oom-killer output, please.
> 
> 
Our ia64 server's USB/e100 device uses 32bit-PCI, so sometimes OOM happens on DMA zone.
(ia64's ZONE_DMA is 0-4G area.)

But very sorry....I was confused.

I looked the issue above again and found ZONE_NORMAL/x86 was exhausted.

This was interesiting incident,

Constructing DB on 4Gb system has no problem.
Constructing DB on 8Gb system always causes OOM.

I asked the users to change DB's parameter. (this happened on RHEL4/linux-2.6.9 series)


> >   And...some customers want to keep memory Free as much as possible.
> >   99% memory usage makes insecure them ;)
> 
> Tell them to do "echo 3 > /proc/sys/vm/drop_caches", then wait three minutes?

Ah, maybe we can use it on RHEL5. We'll test it. thank you.

Thanks,
-Kamezawa



