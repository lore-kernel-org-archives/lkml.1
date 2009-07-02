Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZGBGoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZGBGoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZGBGoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:44:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34194 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZGBGoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:44:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 15:42:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Avi Kivity <avi@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, npiggin@suse.de,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][PATCH] ZERO PAGE again
Message-Id: <20090702154234.d7ee06a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A4B8486.3020307@redhat.com>
References: <20090701185759.18634360.kamezawa.hiroyu@jp.fujitsu.com>
	<4A4B8486.3020307@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 18:45:10 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 07/01/2009 12:57 PM, KAMEZAWA Hiroyuki wrote:
> > ZERO PAGE was removed in 2.6.24 (=>  http://lkml.org/lkml/2007/10/9/112)
> > and I had no objections.
> >
> > In these days, at user support jobs, I noticed a few of customers
> > are making use of ZERO_PAGE intentionally...brutal mmap and scan, etc. They are
> > using RHEL4-5(before 2.6.18) then they don't notice that ZERO_PAGE
> > is gone, yet.
> > yes, I can say  "ZERO PAGE is gone" to them in next generation distro.
> >
> > Recently, a question comes to lkml (http://lkml.org/lkml/2009/6/4/383
> >
> > Maybe there are some users of ZERO_PAGE other than my customers.
> > So, can't we use ZERO_PAGE again ?
> >
> > IIUC, the problem of ZERO_PAGE was
> >    - reference count cache ping-pong
> >    - complicated handling.
> >    - the behavior page-fault-twice can make applications slow.
> >
> > This patch is a trial to de-refcounted ZERO_PAGE.
> > Any comments are welcome. I'm sorry for digging grave...
> >    
> 
> kvm could use this.  There's a fairly involved scenario where the lack 
> of zero page hits us:
> 
> - a guest is started
> - either it doesn't touch all of its memory, or it balloons some of its 
> memory away, so its resident set size is smaller than the total amount 
> of memory it has
> - the guest is live migrated to another host; this involves reading all 
> of the guest memory
> 
> If we don't have zero page, all of the not-present pages are faulted in 
> and the resident set size increases; this increases memory pressure, 
> which is what we're trying to avoid (one of the reasons to live migrate 
> is to free memory).
> 

Thank you. I'll make this patch cleaner and fix my English, then post again.
maybe in the next week.

A case I met was the application level migration. An application save its
sparse table by scan-and-dump. To know "all memory contents are zero",
it had to read memory, at least.

Regards,
-Kame




> -- 
> error compiling committee.c: too many arguments to function
> 

