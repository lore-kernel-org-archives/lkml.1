Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbYBSJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbYBSJJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYBSJJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:09:27 -0500
Received: from brick.kernel.dk ([87.55.233.238]:13066 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYBSJJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:09:26 -0500
Date: Tue, 19 Feb 2008 10:09:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1    softlockup  while bootup on powerpc
Message-ID: <20080219090923.GR23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B67E5E.4010001@linux.vnet.ibm.com> <20080217192913.GO23197@kernel.dk> <20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com> <20080219083633.GN23197@kernel.dk> <20080219174743.202b64f8.kamezawa.hiroyu@jp.fujitsu.com> <20080219085838.GP23197@kernel.dk> <20080219180723.e742a582.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219180723.e742a582.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, KAMEZAWA Hiroyuki wrote:
> On Tue, 19 Feb 2008 09:58:38 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> > > when I inserted printk here
> > > ==
> > > 	for (i = 0; i < nr; i++)
> > > 		func(ioc, cics[i]);
> > > 	printk("%d %lx\n", nr, index);
> > > ==
> > > index was always "1" and  nr was always 32.
> > > 
> > > So, cics[31]->key was always NULL when index=1 is passed to
> > > radix_tree_gang_lookup().
> > 
> > Hang on, it returned 32? It should not return more than 16, since that
> > is what we have room for and asked for. 
> sorry. Of course, it was 16 ;(

I expected so, otherwise we would have had far more serious problems :-)

> your patch works well. thank you.

It's committed now and posted in the relevant bugzilla as well (#9948).

-- 
Jens Axboe

