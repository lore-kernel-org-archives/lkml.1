Return-Path: <linux-kernel-owner+w=401wt.eu-S965554AbXCATwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554AbXCATwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbXCATwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:52:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965550AbXCATwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:52:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anton Blanchard <anton@samba.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Date: Thu, 1 Mar 2007 20:54:25 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <200703011609.43804.rjw@sisk.pl> <20070301193826.GA14587@kryten>
In-Reply-To: <20070301193826.GA14587@kryten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703012054.26940.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 March 2007 20:38, Anton Blanchard wrote:
> 
> Hi,
> 
> > Remove PF_NOFREEZE from the rcutorture thread, adding a
> > try_to_freeze() call as required.
> 
> ...
> 
> > @@ -607,6 +607,7 @@ rcu_torture_writer(void *arg)
> >  		}
> >  		rcu_torture_current_version++;
> >  		oldbatch = cur_ops->completed();
> > +		try_to_freeze();
> >  	} while (!kthread_should_stop() && !fullstop);
> >  	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
> >  	while (!kthread_should_stop())
> 
> I wonder if it makes sense to embed try_to_freeze() into the kthread
> API somewhere. Short of that we should document the try_to_freeze()
> requirement in the kthread documentation... Unfortunately I cant find
> any kthread docs in Documentation/ :)

Well, the patch is from Paul, so I think he'll be able to comment. :-)

Greetings,
Rafael
