Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0CLAKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:10:06 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37459 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab0CLAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:10:04 -0500
From: nhorman@mail.tuxdriver.com
To: "Andi Kleen" <andi@firstfloor.org>, "Neil Horman" <nhorman@tuxdriver.com>
Cc: "Mel Gorman" <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Andi Kleen" <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 11 Mar 2010 19:09:35 -0500
User-Agent: LogicMail/1.0.4
Subject: Re: mmotm 2010-03-09-19-15: Lot of scheduling while atomic warnings related to RCU
In-Reply-To: <20100311223048.GI20695@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
    charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1NpsRW-0006gl-Cm@smtp.tuxdriver.com>
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 11 Mar 2010 17:30:48 -0500, Andi Kleen wrote:
> > a/lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
> > +++ a/lib/kobject_uevent.c
> > @@ -273,10 +273,11 @@ int kobject_uevent_env(struct kobject *k
> >  #endif
> > 
> >         /* call uevent_helper, usually only enabled during early boot */
> > +       rcu_read_lock();
> >         helper = rcu_dereference(uevent_helper);
> >         if (helper[0])
> >                 retval = uevent_call_helper(subsystem, env);
> > -
> > +       rcu_read_unlock();
> >  exit:
> 
> The data actually has to be copied, there's a helper for this in rcustring.
> I'll try to send a patch later.
> 
> > loads/unloads while changing uevent_helper.  Anywho, should be easy to fix,
> > Mel, can you modify the code to copy helper to a private variable, then unlock
> > the rcu read side prior to calling uevent_call_helper?  I imagine that would be
> 
> Yes, except rcustring already has a helper for that :)
> 
Yes but the rcustring bits all got reverted, trashing my series :), so its all got to be rediffed anyway

Neil
> -Andi
> 

