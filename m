Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbYCWJMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbYCWJMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932492AbYCWIsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:48:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46829 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762977AbYCWIsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:48:16 -0400
Date: Sun, 23 Mar 2008 17:47:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 103 sec. latency: sync_page() with TASK_UNINTERRUPTIBLE (?) (bisected)
Cc: kosaki.motohiro@jp.fujitsu.com, "Carlos R. Mafra" <crmafra2@gmail.com>,
       linux-kernel@vger.kernel.org, riel@redhat.com, rjw@sisk.pl
In-Reply-To: <20080322224143.0e2901cd.akpm@linux-foundation.org>
References: <20080323034725.GA3781@localhost.ift.unesp.br> <20080322224143.0e2901cd.akpm@linux-foundation.org>
Message-Id: <20080323174142.B31A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > I bisected it down to f1a9ee758de7de1e040de849fdef46e6802ea117
> > ("kswapd should only wait on IO if there is IO").
> > 
> > If a revert the above commit from the latest git kernel
> > (v2.6.25-rc6-243-g028011e), then I get an very good interactivity
> > while xjed is loading the 380MB file (meaning that I can do other things
> > during the load). Otherwise it takes almost 3 times longer to load,
> > and interactivity is very bad in the meanwhile. I doubled checked it.
> > 
> > I hope this information will be useful, and I can try any patches
> > if necessary.
> > 
> 
> Thanks, I queued the below reversion.  It would be great if you could
> confirm that this patch does indeed make 2.6.25-rc6 work as well as 2.6.24.
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Revert
> 
> commit f1a9ee758de7de1e040de849fdef46e6802ea117
> Author: Rik van Riel <riel@redhat.com>
> Date:   Thu Feb 7 00:14:08 2008 -0800
> 
>     kswapd should only wait on IO if there is IO

if you don't mind, I hope join to test to this patch.
I think his basic idea is good.
but unfortunately, it has corner case problem.
if do more test and remove any regression, this patch is valuable
for merge again.


- kosaki


