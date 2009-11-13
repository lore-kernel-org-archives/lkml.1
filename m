Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZKMLcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZKMLcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZKMLch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:32:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39429 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbZKMLcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:32:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Allow memory hotplug and hibernation in the same kernel
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-mm@kvack.org, gerald.schaefer@de.ibm.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, Yasunori Goto <y-goto@jp.fujitsu.com>
In-Reply-To: <20091113200745.33CE.A69D9226@jp.fujitsu.com>
References: <20091113105944.GA16028@basil.fritz.box> <20091113200745.33CE.A69D9226@jp.fujitsu.com>
Message-Id: <20091113203151.33D1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 13 Nov 2009 20:32:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (cc to goto-san)
> 
> > Allow memory hotplug and hibernation in the same kernel
> > 
> > Memory hotplug and hibernation was excluded in Kconfig. This is obviously
> > a problem for distribution kernels who want to support both in the same
> > image.
> 
> Sure.
> 
> This exclusion is nearly meaningless. if anybody remove cpu, memory and/or
> various peripheral from hibernated machine. the system might not resume.
> it's obvious. memory is not special.
> 
> Documentation/power/swsusp.txt explicitly said
> 
> 	 * BIG FAT WARNING *********************************************************
> 	 *
> 	 * If you touch anything on disk between suspend and resume...
> 	 *                              ...kiss your data goodbye.
> 
> 
> I like this patch.
> 
> 
> > 
> > After some discussions with Rafael and others the only problem is 
> > with parallel memory hotadd or removal while a hibernation operation
> > is in process. It was also working for s390 before.
> > 
> > This patch removes the Kconfig level exclusion, and simply
> > makes the memory add / remove functions grab the pm_mutex
> > to exclude against hibernation.
> > 
> > This is a 2.6.32 candidate.

2.6.32?




