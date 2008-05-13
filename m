Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYEMLAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYEMLAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYEMK77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:59:59 -0400
Received: from trantor.org.uk ([213.146.130.142]:43171 "EHLO
	trantor.trantor.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYEMK77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:59:59 -0400
Subject: Re: oprofile BUG() in current kernel.
From: Gianni Tedesco <gxt@cs.nott.ac.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, arges@linux.vnet.ibm.com,
       Maynard Johnson <maynardj@us.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Mike Travis <travis@sgi.com>
In-Reply-To: <48296C96.8060000@cosmosbay.com>
References: <1210593756.3708.7.camel@dao.KWGR614>
	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
	 <1210599105.3479.1.camel@dao.KWGR614> <48285002.9080702@us.ibm.com>
	 <1210610283.7218.4.camel@snuffleupagus>
	 <20080513014010.e0723e01.akpm@linux-foundation.org>
	 <1210671688.3472.10.camel@dao.KWGR614>  <48296C96.8060000@cosmosbay.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 May 2008 11:59:52 +0100
Message-Id: <1210676392.3939.4.camel@dao.KWGR614>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 12:25 +0200, Eric Dumazet wrote:
> Gianni Tedesco a écrit :
> >
> >
> > Nope, exact same bad paging request in kernel mode... probably the bug
> > is something deep in oprofile then?
> >   
> Hum... Are you using oprofile as a module or statically included in kernel ?

Yes module

> Current module loader only allocates percpu room by examining 
> ".data.percpu" section and should be augmented to also look at 
> ".data.percpu.shared_aligned"
> Or, change DEFINE_PER_CPU_SHARED_ALIGNED() for modules (to use 
> ".data.percpu" only)
> 
> Anyway, with the per_cpu conversion of cpu_buffer, we dont need to 
> request cache_line alignment anymore
> 
> [PATCH] oprofile: Dont request cache line alignment for cpu_buffer

Nice theory, but with percpu + this patch, it still leads to the same
BUG trap :(

