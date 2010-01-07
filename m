Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944Ab0AGUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0AGUJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185Ab0AGUJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:09:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783Ab0AGUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:09:18 -0500
Date: Thu, 7 Jan 2010 12:08:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.DEB.2.00.1001071308320.2981@router.home>
Message-ID: <alpine.LFD.2.00.1001071207040.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105054536.44bf8002@infradead.org>  <alpine.DEB.2.00.1001050916300.1074@router.home>  <20100105192243.1d6b2213@infradead.org>  <alpine.DEB.2.00.1001071007210.901@router.home>
  <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain> <1262884960.4049.106.camel@laptop> <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain> <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain> <alpine.LFD.2.00.1001071031440.7821@localhost.localdomain>
 <alpine.DEB.2.00.1001071308320.2981@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Christoph Lameter wrote:
> 
> page_table_lock used to serialize multiple fast brks?
> 
> CONFIG_SPLIT_PTLOCK implies that code will not use this lock in fault
> handling. So no serialization with faults.

Correct. The faults we do not need to serialize with. It doesn't matter 
whether they see the old or the new end. 

> Also the current code assumes vm_end and so on to be stable if mmap_sem is
> held. F.e. find_vma() from do_fault is now running while vm_end may be changing
> under it.

Again, it doesn't matter. Old or new - if some other thread looks up the 
vma, either is fine.

			Linus
