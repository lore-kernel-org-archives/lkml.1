Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZIHOEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZIHOEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZIHOEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:04:44 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:36330 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752251AbZIHOEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:04:44 -0400
Date: Tue, 8 Sep 2009 10:03:42 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
In-Reply-To: <1252411520.7746.68.camel@twins>
Message-ID: <alpine.DEB.1.10.0909081000100.15723@V090114053VZO-1>
References: <20090908190148.0CC9.A69D9226@jp.fujitsu.com>  <1252405209.7746.38.camel@twins>  <20090908193712.0CCF.A69D9226@jp.fujitsu.com> <1252411520.7746.68.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Peter Zijlstra wrote:

> This is about avoiding work when there is non, clearly when an
> application does use the kernel it creates work.

Hmmm. The lru draining in page migration is to reduce the number of pages
that are not on the lru to increase the chance of page migration to be
successful. A page on a per cpu list cannot be drained.

Reducing the number of cpus where we perform the drain results in
increased likelyhood that we cannot migrate a page because its on the per
cpu lists of a cpu not covered.

On the other hand if the cpu is offline then we know that it has no per
cpu pages. That is why I found the idea of the OFFLINE
scheduler attractive.
