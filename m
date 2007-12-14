Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbXLNJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbXLNJv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXLNJvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:51:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072AbXLNJvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:51:16 -0500
Date: Fri, 14 Dec 2007 01:49:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       jirislaby@gmail.com, Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.24-rc5-mm1
Message-Id: <20071214014906.eb2644f4.akpm@linux-foundation.org>
In-Reply-To: <20071213122802.GA30427@in.ibm.com>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<20071213122802.GA30427@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 17:58:02 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:

> Hi Andrew, 
> On Thu, Dec 13, 2007 at 02:40:50AM -0800, Andrew Morton wrote:
> > 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
> > 
> > - If something goes wrong with a PCI device's probing or initialisation, try
> >   reverting pci-disable-decoding-during-sizing-of-bars.patch.
> > 
> > - git-sched was dropped due to breaking suspend-to-RAM.
> 
> Is it the same suspend-to-RAM problem that Jiri Slaby reported 
> here --> http://lkml.org/lkml/2007/12/7/125
> 
> The problem has been identified and a fix patch was provided.
> 

Here we go...

From: Andrew Morton <akpm@linux-foundation.org>

Revert from git-sched:

commit 9e76ad89f4fa93a789326bc0f4548cd2fbca8d8e
Author: Gregory Haskins <ghaskins@novell.com>
Date:   Thu Dec 13 21:35:26 2007 +0100

    sched: update root-domain spans upon departure
    
    We shouldnt leave cpus enabled in the spans if that RQ has left the domain.
    
    Signed-off-by: Gregory Haskins <ghaskins@novell.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

As it causes my t61p to fail to come back to life after suspend-to-RAM.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/sched.c~revert-sched-update-root-domain-spans-upon-departure kernel/sched.c
--- a/kernel/sched.c~revert-sched-update-root-domain-spans-upon-departure
+++ a/kernel/sched.c
@@ -5854,9 +5854,6 @@ static void rq_attach_root(struct rq *rq
 				class->leave_domain(rq);
 		}
 
-		cpu_clear(rq->cpu, old_rd->span);
-		cpu_clear(rq->cpu, old_rd->online);
-
 		if (atomic_dec_and_test(&old_rd->refcount))
 			kfree(old_rd);
 	}
_

