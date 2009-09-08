Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZIHPXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZIHPXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZIHPXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:23:46 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:60280 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213AbZIHPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:23:45 -0400
Date: Tue, 8 Sep 2009 11:22:08 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
In-Reply-To: <1252419602.7746.73.camel@twins>
Message-ID: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
References: <20090908190148.0CC9.A69D9226@jp.fujitsu.com>  <1252405209.7746.38.camel@twins>  <20090908193712.0CCF.A69D9226@jp.fujitsu.com>  <1252411520.7746.68.camel@twins>  <alpine.DEB.1.10.0909081000100.15723@V090114053VZO-1>
 <1252419602.7746.73.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Peter Zijlstra wrote:

> There is _no_ functional difference between before and after, except
> less wakeups on cpus that don't have any __lru_cache_add activity.
>
> If there's pages on the per cpu lru_add_pvecs list it will be present in
> the mask and will be send a drain request. If its not, then it won't be
> send.

Ok I see.

A global cpu mask like this will cause cacheline bouncing. After all this
is a hot cpu path. Maybe do not set the bit if its already set
(which may be very frequent)? Then add some benchmarks to show that it
does not cause a regression on a 16p box (Nehalem) or so?






