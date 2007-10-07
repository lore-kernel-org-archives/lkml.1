Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXJGOiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXJGOiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 10:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXJGOip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 10:38:45 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:63160 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXJGOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 10:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EmqOCYd9yBAUQQXPGB7lUagb35tPbeNUmCuMJU9TvTUSZjiKCfwBBSdLrZJ1RGQyJHNzGmhATdHsIphMOheBc49OHNPdvAqiRZGoT+U/bDxDAYM2Es47gsFTSic7Jfw3Dtf6NPZYg4mno3J2IDlplLMIVALRGh0nlW2jUytNm50=
Subject: Re: Sleeping in RCU list traversal
From: Jun WANG <junwang1234@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710072226.EJF51558.LFVHJOStFOOFMQ@I-love.SAKURA.ne.jp>
References: <1191784307.3618.8.camel@localhost.localdomain>
	 <200710072226.EJF51558.LFVHJOStFOOFMQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: HITSZ
Date: Mon, 08 Oct 2007 06:37:20 +0800
Message-Id: <1191796640.3045.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello.
> 
> Thank you for pointing out.
> 
> Jun WANG wrote:
> > >rcu_read_lock();
> > >list_for_each_rcu(p, ...) {
> > >   ptr = list_entry(p, struct ..., list);
> > >   /* Grab a reference to "ptr". */
> > >   rcu_read_unlock();
> > >   my_task_that_may_sleep(ptr);
> > >   rcu_read_lock();
> > >   /* Drop a reference to "ptr". */
> > > }
> > > rcu_read_unlock();
>>>Regarding my case, memory region pointed by "ptr" never be removed.
>>>Do I need to grab a reference to "ptr" ?
> > 
> > In Document/RCU/whatisRCU.txt
> > Note that the value returned by rcu_dereference() is valid
> > 	only within the enclosing RCU read-side critical section.
> Excuse me, but I think "p" is used only between rcu_read_lock() and rcu_read_unlock().
> Is it illegal to use "ptr" after rcu_read_unlock() if "ptr" is obtained before rcu_read_unlock() ?
> 
> Regards.
> 
I'm sorry,I think I got your idea, if you do not need ptr in
my_task_that_may_sleep(), why you need to grab a reference to "ptr". If
your my_task_that_may_sleep() needs ptr, and according to the 
>"memory region pointed by "ptr" never be removed." you say,
it is ok to use "ptr" after rcu_read_ulock(). The basic idea behind RCU
is to split updates into "removal" and "reclamation" phases. If you
memory region pointed by "ptr" will not "reclamation" in sleep, it is ok

Regards.

