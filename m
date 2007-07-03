Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXGCNMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXGCNMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXGCNMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:12:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbXGCNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:12:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Date: Tue, 3 Jul 2007 15:19:58 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
References: <200706252352.24137.rjw@sisk.pl> <200706260027.02396.rjw@sisk.pl> <1183440646.10386.66.camel@localhost.localdomain>
In-Reply-To: <1183440646.10386.66.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031519.59661.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 07:30, Benjamin Herrenschmidt wrote:
> On Tue, 2007-06-26 at 00:27 +0200, Rafael J. Wysocki wrote:
> > > >     case PM_HIBERNATION_PREPARE:
> > > >     case PM_SUSPEND_PREPARE:
> > > >             usermodehelper_disabled = 1;
> > > > -           return NOTIFY_OK;
> > > > +           smp_mb();
> > > 
> > > usermodehelper_disabled should be atomic variable, too, so we don't
> > > have to play these ugly tricks by hand? This should not be
> > > performance-critical, right?
> > 
> > Well, I think we'd need to add the barriers anyway.
> > 
> > The problem, as far as I understand it, is that the instructions can
> > get
> > reordered if there are no barriers in there.
> 
> That seems dodgy either way to me :-)
> 
> Just use a spinlock.

Around wait_for_completion()?  I don't think that's a good idea. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
