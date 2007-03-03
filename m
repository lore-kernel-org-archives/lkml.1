Return-Path: <linux-kernel-owner+w=401wt.eu-S2992833AbXCCBBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992833AbXCCBBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992835AbXCCBBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:01:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992833AbXCCBBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:01:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Date: Sat, 3 Mar 2007 02:03:58 +0100
User-Agent: KMail/1.9.5
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <20070302213549.GC2373@linux.vnet.ibm.com> <20070302233337.GA267@tv-sign.ru>
In-Reply-To: <20070302233337.GA267@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703030203.59770.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 3 March 2007 00:33, Oleg Nesterov wrote:
> On 03/02, Paul E. McKenney wrote:
> >
> > One way to embed try_to_freeze() into kthread_should_stop() might be
> > as follows:
> > 
> > 	int kthread_should_stop(void)
> > 	{
> > 		if (kthread_stop_info.k == current)
> > 			return 1;
> > 		try_to_freeze();
> > 		return 0;
> > 	}
> 
> I think this is dangerous. For example, worker_thread() will probably
> need some special actions after return from refrigerator. Also, a kernel
> thread may check kthread_should_stop() in the place where try_to_freeze()
> is not safe.
> 
> Perhaps we should introduce a new helper which does this.

Agreed.

Rafael
