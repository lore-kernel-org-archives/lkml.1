Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbZIIE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbZIIE1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZIIE1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:27:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40690 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZIIE1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:27:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1>
References: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1> <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1>
Message-Id: <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 13:27:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The usefulness of a scheme like this requires:
> 
> 1. There are cpus that continually execute user space code
>    without system interaction.
> 
> 2. There are repeated VM activities that require page isolation /
>    migration.
> 
> The first page isolation activity will then clear the lru caches of the
> processes doing number crunching in user space (and therefore the first
> isolation will still interrupt). The second and following isolation will
> then no longer interrupt the processes.
> 
> 2. is rare. So the question is if the additional code in the LRU handling
> can be justified. If lru handling is not time sensitive then yes.

Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
I think page migration don't need lru_add_drain_all() as synchronous, because
page migration have 10 times retry.

Then asynchronous lru_add_drain_all() cause

  - if system isn't under heavy pressure, retry succussfull.
  - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.

I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.

What do you think?


