Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYBSItJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYBSItJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYBSIs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:48:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYBSIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:48:56 -0500
Date: Tue, 19 Feb 2008 17:47:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1 
 softlockup  while bootup on powerpc
Message-Id: <20080219174743.202b64f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080219083633.GN23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<47B67E5E.4010001@linux.vnet.ibm.com>
	<20080217192913.GO23197@kernel.dk>
	<20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com>
	<20080219083633.GN23197@kernel.dk>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 09:36:34 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Feb 19 2008, KAMEZAWA Hiroyuki wrote:
> > On Sun, 17 Feb 2008 20:29:13 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > It's odd stuff. Could you perhaps try and add some printks to
> > > block/cfq-iosched.c:call_for_each_cic(), like dumping the 'nr' return
> > > from radix_tree_gang_lookup() and the pointer value of cics[i] in the
> > > for() loop after the lookup?
> > > 
> > I met the same issue on ia64/NUMA box.
> > seems cisc[]->key is NULL and index for radix_tree_gang_lookup() was
> > always '1'.
> 
> Why does it keep repeating then? If ->key is NULL, the next lookup index
> should be 1UL.
> 
when I inserted printk here
==
	for (i = 0; i < nr; i++)
		func(ioc, cics[i]);
	printk("%d %lx\n", nr, index);
==
index was always "1" and  nr was always 32.

So, cics[31]->key was always NULL when index=1 is passed to radix_tree_gang_lookup().


> But I think the radix 'scan over entire tree' is a bit fragile. This
> patch adds a parallel hlist for ease of properly browsing the members,
> does that work for you? It compiles, but I haven't booted it here yet...
> 
will try. please wait a bit.

Thanks,
-Kame

