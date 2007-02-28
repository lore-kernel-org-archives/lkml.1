Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbXB0X6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbXB0X6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXB0X6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:58:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbXB0X6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:58:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 01:00:35 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <1172619412.3681.11.camel@johannes.berg>
In-Reply-To: <1172619412.3681.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702280100.36649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 00:36, Johannes Berg wrote:
> On Wed, 2007-02-28 at 02:28 +0300, Oleg Nesterov wrote:
> 
> > Ugh. I know nothing, nothing, nothing about suspend. I'll try to guess.
> > 
> >    Commit: ed746e3b18f4df18afa3763155972c5835f284c5
> 
> > Yes? with the patch above, _cpu_down() called _after_ freeze_processes() ???
> 
> perfect :)
> See also my original mail and the thread:
> http://thread.gmane.org/gmane.linux.power-management.general/4314
> 
> > How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callback() ?
> 
> I'd they should be affected as well.

They won't be, if they have PF_NOFREEZE set.

> For me, I guess I haven't run into them because xfs is enough to freeze the
> box ;)

I think you've hit the only thing that could have triggered the issue. ;-)

Greetings,
Rafael
