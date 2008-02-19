Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYBSJIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYBSJIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYBSJHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:07:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35856 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYBSJHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:07:46 -0500
Date: Tue, 19 Feb 2008 18:07:23 +0900
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
Message-Id: <20080219180723.e742a582.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080219085838.GP23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<47B67E5E.4010001@linux.vnet.ibm.com>
	<20080217192913.GO23197@kernel.dk>
	<20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com>
	<20080219083633.GN23197@kernel.dk>
	<20080219174743.202b64f8.kamezawa.hiroyu@jp.fujitsu.com>
	<20080219085838.GP23197@kernel.dk>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 09:58:38 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:
> > when I inserted printk here
> > ==
> > 	for (i = 0; i < nr; i++)
> > 		func(ioc, cics[i]);
> > 	printk("%d %lx\n", nr, index);
> > ==
> > index was always "1" and  nr was always 32.
> > 
> > So, cics[31]->key was always NULL when index=1 is passed to
> > radix_tree_gang_lookup().
> 
> Hang on, it returned 32? It should not return more than 16, since that
> is what we have room for and asked for. 
sorry. Of course, it was 16 ;(

your patch works well. thank you.

-Kame

