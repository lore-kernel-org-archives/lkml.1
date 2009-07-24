Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZGXBKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZGXBKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 21:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZGXBKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 21:10:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52193 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZGXBKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 21:10:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
In-Reply-To: <alpine.DEB.2.00.0907231624480.3476@chino.kir.corp.google.com>
References: <20090722233347.776E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0907231624480.3476@chino.kir.corp.google.com>
Message-Id: <20090724083802.1E37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 24 Jul 2009 10:10:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 24 Jul 2009, KOSAKI Motohiro wrote:
> 
> > > It's the API that's existed for years with no complaints, AFAICS.
> > 
> > I think thead and vfork() should be separeted on this discussion.
> > I agree vfork() regression should be fixed. but I don't think anyone
> > hope per-thread oom score. 
> > 
> > Of cource, if simple reverting is best way, I don't oppose this.... ;-)
> > 
> 
> Simply reverting it isn't an option unless you fix the underlying livelock 
> problem that my patches originally addressed and no viable alternative has 
> been proposed.

I disagree.
I agree with old behavior have one bug. but it doesn't provide any regression
allowing reason although old behavior is totally suck.

David, We already know your patch break real application. it is never acceptable.


> On the other hand, I think adding /proc/pid/oom_adj_child would solve the 
> userspace issue.  oom_adj_child would be the oom_adj value that is used by 
> the newly initialized mm_struct; this would allow the vfork'd child to 
> share the same oom_score with the parent and then be replaced with an 
> alternate score on execve().

Not solve. "please rewrite your application" isn't good solution.

Hm...
This is just idea, Does moving oom_adj from mm_struct to signal_struct solve
this problem?
I mean vfork() share mm_struct, but doesn't share signal_struct.




> 
> oom_adj_child would only be allowed to be greater (i.e. the more preferred 
> victim) than oom_adj for any given thread since the oom killer tries to 
> kill a child of the selected task first if it doesn't share memory.


