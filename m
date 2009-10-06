Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZJFB0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZJFB0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbZJFB0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:26:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38207 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbZJFB0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:26:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Cc: kosaki.motohiro@jp.fujitsu.com, Frans Pop <elendil@planet.nl>,
       Mel Gorman <mel@csn.ul.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
References: <200910052334.23833.elendil@planet.nl> <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
Message-Id: <20091006102110.5F9D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 10:25:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 5 Oct 2009, Frans Pop wrote:
> 
> > And the winner is:
> > 2ff05b2b4eac2e63d345fc731ea151a060247f53 is first bad commit
> > commit 2ff05b2b4eac2e63d345fc731ea151a060247f53
> > Author: David Rientjes <rientjes@google.com>
> > Date:   Tue Jun 16 15:32:56 2009 -0700
> > 
> >     oom: move oom_adj value from task_struct to mm_struct
> > 
> > I'm confident that the bisection is good. The test case was very reliable 
> > while zooming in on the merge from akpm.
> > 
> 
> I doubt it for two reasons: (i) this commit was reverted in 0753ba0 since 
> 2.6.31-rc7 and is no longer in the kernel, and (ii) these are GFP_ATOMIC 
> allocations which would be unaffected by oom killer scores.

I agree. this patch is pretty obvious correct. it was reverted by
one unfortunately regression.


