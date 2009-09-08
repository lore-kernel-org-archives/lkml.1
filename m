Return-Path: <linux-kernel-owner+w=401wt.eu-S1751013AbZIHOUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbZIHOUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZIHOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:20:10 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:15188 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZIHOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:20:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [rfc] lru_add_drain_all() vs isolation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0909081000100.15723@V090114053VZO-1>
References: <20090908190148.0CC9.A69D9226@jp.fujitsu.com>
	 <1252405209.7746.38.camel@twins>
	 <20090908193712.0CCF.A69D9226@jp.fujitsu.com>
	 <1252411520.7746.68.camel@twins>
	 <alpine.DEB.1.10.0909081000100.15723@V090114053VZO-1>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 16:20:02 +0200
Message-Id: <1252419602.7746.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 10:03 -0400, Christoph Lameter wrote:
> On Tue, 8 Sep 2009, Peter Zijlstra wrote:
> 
> > This is about avoiding work when there is non, clearly when an
> > application does use the kernel it creates work.
> 
> Hmmm. The lru draining in page migration is to reduce the number of pages
> that are not on the lru to increase the chance of page migration to be
> successful. A page on a per cpu list cannot be drained.
> 
> Reducing the number of cpus where we perform the drain results in
> increased likelyhood that we cannot migrate a page because its on the per
> cpu lists of a cpu not covered.

Did you even read the patch?

There is _no_ functional difference between before and after, except
less wakeups on cpus that don't have any __lru_cache_add activity.

If there's pages on the per cpu lru_add_pvecs list it will be present in
the mask and will be send a drain request. If its not, then it won't be
send.



