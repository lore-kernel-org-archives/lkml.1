Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZBWMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZBWMA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZBWMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:00:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZBWMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:00:18 -0500
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090223114541.GD31277@linux.vnet.ibm.com>
References: <20090216103636.GC17355@linux.vnet.ibm.com>
	 <1234782516.4703.15.camel@laptop>
	 <20090216120213.GB3925@linux.vnet.ibm.com>
	 <1234787082.30178.3.camel@laptop>
	 <20090216131440.GC3925@linux.vnet.ibm.com>
	 <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org>
	 <20090217050033.GA10409@linux.vnet.ibm.com>
	 <20090217101542.GB15989@linux.vnet.ibm.com>
	 <1234869339.4744.77.camel@laptop>
	 <20090223114541.GD31277@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 12:59:56 +0100
Message-Id: <1235390396.4645.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 17:15 +0530, Dhaval Giani wrote:
> On Tue, Feb 17, 2009 at 12:15:39PM +0100, Peter Zijlstra wrote:
> > On Tue, 2009-02-17 at 15:45 +0530, Dhaval Giani wrote:
> > 
> > > sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> > > 
> > > Corey Hickey reported that on using setuid to change the uid of a
> > > rt process, the process would be unkillable and not be running.
> > > This is because there was no rt runtime for that user group. Add
> > > in a check to see if a user can attach an rt task to its task group.
> > 
> > This looks good to me.
> > 
> > Does anybody object to the -ENOSPC return value? Should we introduce
> > -ENOTIME for that?
> > 
> > Michael, Alan?
> > 
> 
> Hi,
> 
> Any comments on which return value to return? Should we introduce
> -ENOTIME?
> 
> Corey mentioned he found ENOSPC confusing.

I'd say go for the ENOTIME thing.

