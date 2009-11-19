Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZKSApi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZKSApi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbZKSAph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:45:37 -0500
Received: from mga06.intel.com ([134.134.136.21]:49277 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756881AbZKSAph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:45:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,767,1249282800"; 
   d="scan'208";a="468570633"
Subject: Re: [MM] Make mm counters per cpu instead of atomic
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	 <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost>
	 <1258450465.11321.36.camel@localhost>
	 <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 19 Nov 2009 08:48:07 +0800
Message-Id: <1258591687.11321.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 12:25 -0500, Christoph Lameter wrote:
> On Tue, 17 Nov 2009, Zhang, Yanmin wrote:
> 
> > The right change above should be:
> >  struct mm_counter *m = per_cpu_ptr(mm->rss, cpu);
> 
> Right.
> 
> > With the change, command 'make oldconfig' and a boot command still
> > hangs.
> 
> Not sure if its worth spending more time on this but if you want I will
> consolidate the fixes so far and put out another patchset.
> 
> Where does it hang during boot?
> 
1) A init boot script calss pidof and pidof hands in
access_process_vm => (mutex_lock <=> mutex_unlock), so actually in
mm_reader_lock.
2) 'make oldconfig' hangs in sys_map => msleep, actually in mm_writer_lock.

I will check it today.



