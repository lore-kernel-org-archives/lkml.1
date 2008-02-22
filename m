Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbYBVHiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbYBVHiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYBVHiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:38:13 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYBVHiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:38:12 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 02:38:12 EST
Date: Thu, 21 Feb 2008 23:24:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1 
 softlockup  while bootup on powerpc
Message-Id: <20080221232418.b93db8d9.akpm@linux-foundation.org>
In-Reply-To: <20080219083633.GN23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<47B67E5E.4010001@linux.vnet.ibm.com>
	<20080217192913.GO23197@kernel.dk>
	<20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com>
	<20080219083633.GN23197@kernel.dk>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 09:36:34 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:

> But I think the radix 'scan over entire tree' is a bit fragile.

eek, it had better not be.  Was this an error in the caller?  Hope so.

> This
> patch adds a parallel hlist for ease of properly browsing the members,

Even though io_contexts are fairly uncommon, adding more stuff to a data
structure was a pretty sad alternative to fixing a bug in
radix_tree_gang_lookup(), or to fixing a bug in a caller of it.

IOW: what exactly went wrong here??
