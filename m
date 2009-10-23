Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZJWO7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZJWO7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZJWO7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:59:51 -0400
Received: from ozlabs.org ([203.10.76.45]:43711 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZJWO7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:59:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Paris <eparis@redhat.com>
Subject: Re: request_module vs. modprobe blacklist (and security subsystem implications)
Date: Sat, 24 Oct 2009 01:29:52 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       randy.dunlap@oracle.com, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com> <200910231946.39174.rusty@rustcorp.com.au> <1256307830.4443.158.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1256307830.4443.158.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910240129.53622.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Oct 2009 12:53:50 am Eric Paris wrote:
> On Fri, 2009-10-23 at 19:46 +1030, Rusty Russell wrote:
> > On Fri, 23 Oct 2009 01:00:22 am Eric Paris wrote:
> > > > If a userspace program tries some security exploit that has been closed, do
> > > > you want to warn about it?  Because that seems to be the question here.
> > > 
> > > I say yes.  Knowing that malicious activity is taking place, even if it
> > > didn't hurt anything is useful.
> > 
> > Hi Eric,
> > 
> > Your proposal is troubling for three reasons:
> > 
> > 1) You would disable logging for things you actually want logged.
> 
> I would?

Yep, admin disables loading of ipx to prevent hole.  Now, you no longer get
logging notification.

> > 2) What *actually* happens when ssh tries to load ipv6 is that
> >    "modprobe net-pf-10" gets called.
> > 3) Containing modprobe behavior in one set of config files is really nice.
> 
> It is it also means that we, somewhat regularly call userspace
> needlessly and there is nothing an admin can do to stop it.

Yes, but that's nothing to do with SELinux; we exec modprobe for no effect.
Yet I've yet to see a report that this is a performance issue.  These brains
are in userspace for a reason.

> But it appears you disagree that fixing that problem is worth it, and I
> don't feel strongly enough to keep arguing  :)

But we have learnt something, at least!

Cheers,
Rusty.
