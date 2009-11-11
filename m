Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZKKAEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZKKAEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZKKAEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:04:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45474 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703AbZKKAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:04:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Cc: kosaki.motohiro@jp.fujitsu.com, Sean Foley <Sean_Foley@ca.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>
In-Reply-To: <1257884209.3139.17.camel@localhost>
References: <20091110141406.3603.A69D9226@jp.fujitsu.com> <1257884209.3139.17.camel@localhost>
Message-Id: <20091111090141.FD2A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 09:04:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-11-10 at 14:27 +0900, KOSAKI Motohiro wrote:
> > Hi Sean, John,
> > 
> > > Kosaki,
> > > Here are a couple of use cases previously posted to this thread on the linux kernel mailing list:
> > > 
> > > dispatch thread adds context to thread names:
> > > http://marc.info/?l=linux-kernel&m=125660141231348&w=2
> > > 
> > > java language support:
> > > http://marc.info/?l=linux-kernel&m=125666430720863&w=2
> > > 
> > > 
> > > 
> > > Here are some various specific use cases from the web:
> > > 
> > > Attaching additional info to thread names when used for different purposes:
> > > http://osdir.com/ml/java.jsr.166-concurrency/2006-12/msg00105.html
> > > 
> > > Threads obtained from thread pools being reassigned new names:
> > > http://haacked.com/archive/2004/06/07/546.aspx
> > > http://bytes.com/topic/c-sharp/answers/637152-naming-backgroundworker-thread
> > > 
> > > Renaming threads scattered across third-party libraries by enumerating them and renaming them dynamically:
> > > http://stackoverflow.com/questions/467224/renaming-threads-in-java
> > 
> > Okey, good explanation. thanks!
> > 
> > So, I would suggested to extend /proc/{pid}/cmdline instead using task->comm.
> > because 
> >   - task->comm has nasty locking rule. It is harder to change SMP safe.
> 
> I cc'ed you on the updated patch which addresses this. Please let me
> know if you have specific concerns there.
> 
> >   - ps (and other procps tools) already support /proc/{pid}/cmdline.
> >   - task->comm is restrected 16 character length, /proc/cmdline isn't.
> 
> Part of the reason to use comm is that most tools like perf or oprofile,
> use comm, instead of cmd. 

Ah, good reason. Okey, I will revew your new patch.

thanks.


> Additionally, looking at cmdline, that's per
> mm not per task, right? So it wouldn't really work for thread names. 

Currently, yes. I meaned I think you can enhance it ;)

> Please correct me if I'm not seeing what you're really suggesting.



