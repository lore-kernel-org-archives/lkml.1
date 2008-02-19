Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbYBSJBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbYBSJBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYBSJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:01:23 -0500
Received: from brick.kernel.dk ([87.55.233.238]:2602 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYBSJBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:01:22 -0500
Date: Tue, 19 Feb 2008 10:01:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1   softlockup  while bootup on powerpc
Message-ID: <20080219090119.GQ23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B67E5E.4010001@linux.vnet.ibm.com> <20080217192913.GO23197@kernel.dk> <20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com> <20080219083633.GN23197@kernel.dk> <20080219180242.0bbec245.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219180242.0bbec245.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, KAMEZAWA Hiroyuki wrote:
> On Tue, 19 Feb 2008 09:36:34 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Feb 19 2008, KAMEZAWA Hiroyuki wrote:
> > > On Sun, 17 Feb 2008 20:29:13 +0100
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > It's odd stuff. Could you perhaps try and add some printks to
> > > > block/cfq-iosched.c:call_for_each_cic(), like dumping the 'nr' return
> > > > from radix_tree_gang_lookup() and the pointer value of cics[i] in the
> > > > for() loop after the lookup?
> > > > 
> > > I met the same issue on ia64/NUMA box.
> > > seems cisc[]->key is NULL and index for radix_tree_gang_lookup() was
> > > always '1'.
> > 
> > Why does it keep repeating then? If ->key is NULL, the next lookup index
> > should be 1UL.
> > 
> > But I think the radix 'scan over entire tree' is a bit fragile. This
> > patch adds a parallel hlist for ease of properly browsing the members,
> > does that work for you? It compiles, but I haven't booted it here yet...
> > 
> Works well for me and my box booted !

Super, I'll get it upstream. Thanks for testing and debugging!

-- 
Jens Axboe

