Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbXIGT5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbXIGT5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXIGT5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:57:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51269 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbXIGT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:57:44 -0400
Date: Fri, 7 Sep 2007 12:57:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Pavel Emelianov <xemul@openvz.org>, Zach Brown <zach.brown@oracle.com>,
       Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
Message-ID: <20070907195741.GG8864@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1189175688.28781.167.camel@johannes.berg> <20070907153453.GD8864@linux.vnet.ibm.com> <1189192192.28781.182.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189192192.28781.182.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 09:09:52PM +0200, Johannes Berg wrote:
> On Fri, 2007-09-07 at 08:34 -0700, Paul E. McKenney wrote:
> 
> > > + * Continue to iterate over rcu list of given type, continuing after
> > > + * the current position.
> > 
> > Please add something like the following to this comment:
> > 
> > 	Note that the caller is responsible for making sure that
> > 	the element remains in place between the earlier iterator
> > 	and this one.  One way to do this is to ensure that
> > 	both iterators are covered by the same rcu_read_lock(),
> > 	while others involve reference counts, flags, or mutexes.
> 
> Sure, will do. Should this comment also be added to
> list_for_each_continue_rcu()?

Actually, list_for_each_continue_rcu() needs to be removed in favor of
your new list_for_each_entry_continue_rcu().  There are currently only
two users as of 2.6.22.  One of them immediately does a list_entry(),
and the other would convert easily as well.  So please let me know
when this gets accepted!  ;-)

						Thanx, Paul
