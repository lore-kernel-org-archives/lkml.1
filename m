Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZHCMcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZHCMcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZHCMcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:32:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36550 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbZHCMcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:32:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com>
References: <20090803104244.b58220ba.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com>
Message-Id: <20090803212945.CC2F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  3 Aug 2009 21:32:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for queue jumping. I have one question.


> > >  - /proc/pid/oom_score is inconsistent when the thread that set the
> > >    effective per-mm oom_adj exits and it is now obsolete since you have
> > >    no way to determine what the next effective oom_adj value shall be.
> > > 
> > plz re-caluculate it. it's not a big job if done in lazy way.
> > 
> 
> You can't recalculate it if all the remaining threads have a different 
> oom_adj value than the effective oom_adj value from the thread that is now 
> exited.  There is no assumption that, for instance, the most negative 
> oom_adj value shall then be used.  Imagine the effective oom_adj value 
> being +15 and a thread sharing the same memory has an oom_adj value of 
> -16.  Under no reasonable circumstance should the oom preference of the 
> entire thread then change to -16 just because its the side-effect of a 
> thread exiting.

Why do we need recaluculate AT thread exiting time?
it is only used when oom_score is readed or actual OOM happend.
both those are slow-path.


> 
> That's the _entire_ reason why we need consistency in oom_adj values so 
> that userspace is aware of how the oom killer really works and chooses 
> tasks.  I understand that it differs from the previously allowed behavior, 
> but those userspace applications need to be fixed if, for no other reason, 
> they are now consistent with how the oom killer kills tasks.  I think 
> that's a very worthwhile goal and the cost of moving to a new interface 
> such as /proc/pid/oom_adj_child to have the same inheritance property that 
> was available in the past is justified.



