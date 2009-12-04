Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZLDArc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZLDArc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZLDAra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:47:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39147 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZLDAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:47:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Dec 2009 09:44:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, vedran.furac@gmail.com
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
Message-Id: <20091204094437.4a9ab001.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912031514150.8928@chino.kir.corp.google.com>
References: <20091201131509.5C19.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.0912011414510.27500@chino.kir.corp.google.com>
	<20091202091739.5C3D.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.0912031514150.8928@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 15:25:05 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> If Andrew pushes the patch to change the baseline to rss 
> (oom_kill-use-rss-instead-of-vm-size-for-badness.patch) to Linus, I'll 
> strongly nack it because you totally lack the ability to identify memory 
> leakers as defined by userspace which should be the prime target for the 
> oom killer.  You have not addressed that problem, you've merely talked 
> around it, and yet the patch unbelievably still sits in -mm.
>
It's still cook-time about oom-kill patches and I'll ask Andrew not to send
it when he asks in mm-merge plan. At least, per-mm swap counter and lowmem-rss
counter is necessary. I'll rewrite fork-bomb detector, too.

Repeatedly saying, calculating badness from vm_size _only_ is bad.
I'm not sure how google's magical applications works, but in general,
vm_size doesn't means private memory usage i.e. how well oom-killer can free
pages.
And current oom-killer kills wrong process. Please share your idea to making
oom-killer better rather than just saying "don't do that".

Do you have good algorithm for detecting memory-leaking process in user land ?
I think I added some in my old set but it's not enough.
I'll add more statistics to mm_struct to do better work.

BTW, I hate oom_adj very much. It's nature of "shift" is hard to understand.
I wonder why static oom priority or oom_threshold was not implemented...

Thanks,
-Kame 

