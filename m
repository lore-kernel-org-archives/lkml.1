Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbZFIJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbZFIJpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZFIJpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:45:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33596 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590AbZFIJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:45:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090609094231.GM18380@csn.ul.ie>
References: <20090609173011.DD7F.A69D9226@jp.fujitsu.com> <20090609094231.GM18380@csn.ul.ie>
Message-Id: <20090609184422.DD8B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 18:45:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Here it is just recording the jiffies value. The real smarts with the counter
> > > use time_before() which I assumed could handle jiffie wrap-arounds. Even
> > > if it doesn't, the consequence is that one scan will occur that could have
> > > been avoided around the time of the jiffie wraparound. The value will then
> > > be reset and it will be fine.
> > 
> > time_before() assume two argument are enough nearly time.
> > if we use 32bit cpu and HZ=1000, about jiffies wraparound about one month.
> > 
> > Then, 
> > 
> > 1. zone reclaim failure occur
> > 2. system works fine for one month
> > 3. jiffies wrap and time_before() makes mis-calculation.
> > 
> 
> And the scan occurs uselessly and zone_reclaim_failure gets set again.
> I believe the one useless scan is not significant enough to warrent dealing
> with jiffie wraparound.

Thank you for kindful explanation.
I fully agreed.



