Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZKJF14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZKJF14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZKJF1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:27:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48127 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZKJF1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:27:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Sean Foley <Sean_Foley@ca.ibm.com>, john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>
In-Reply-To: <OF5EE04242.D2B67AF2-ON85257665.0064683D-85257665.0068209E@ca.ibm.com>
References: <20091105143959.2093.A69D9226@jp.fujitsu.com> <OF5EE04242.D2B67AF2-ON85257665.0064683D-85257665.0068209E@ca.ibm.com>
Message-Id: <20091110141406.3603.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 10 Nov 2009 14:27:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sean, John,

> Kosaki,
> Here are a couple of use cases previously posted to this thread on the linux kernel mailing list:
> 
> dispatch thread adds context to thread names:
> http://marc.info/?l=linux-kernel&m=125660141231348&w=2
> 
> java language support:
> http://marc.info/?l=linux-kernel&m=125666430720863&w=2
> 
> 
> 
> Here are some various specific use cases from the web:
> 
> Attaching additional info to thread names when used for different purposes:
> http://osdir.com/ml/java.jsr.166-concurrency/2006-12/msg00105.html
> 
> Threads obtained from thread pools being reassigned new names:
> http://haacked.com/archive/2004/06/07/546.aspx
> http://bytes.com/topic/c-sharp/answers/637152-naming-backgroundworker-thread
> 
> Renaming threads scattered across third-party libraries by enumerating them and renaming them dynamically:
> http://stackoverflow.com/questions/467224/renaming-threads-in-java

Okey, good explanation. thanks!

So, I would suggested to extend /proc/{pid}/cmdline instead using task->comm.
because 
  - task->comm has nasty locking rule. It is harder to change SMP safe.
  - ps (and other procps tools) already support /proc/{pid}/cmdline.
  - task->comm is restrected 16 character length, /proc/cmdline isn't.

You can see prctl-add-pr_set_proctitle_area-option.patch in -mm tree
as enhancement example at first step.



