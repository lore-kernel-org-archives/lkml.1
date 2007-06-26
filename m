Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbXFZMCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbXFZMCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXFZMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:02:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:37882 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbXFZMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:02:30 -0400
Date: Tue, 26 Jun 2007 16:02:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Message-ID: <20070626120241.GA173@tv-sign.ru>
References: <200706252352.24137.rjw@sisk.pl> <20070625215527.GE2051@elf.ucw.cz> <200706260027.02396.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706260027.02396.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Rafael J. Wysocki wrote:
>
> On Monday, 25 June 2007 23:55, Pavel Machek wrote:
> > 
> > >  	case PM_HIBERNATION_PREPARE:
> > >  	case PM_SUSPEND_PREPARE:
> > >  		usermodehelper_disabled = 1;
> > > -		return NOTIFY_OK;
> > > +		smp_mb();
> > 
> > usermodehelper_disabled should be atomic variable, too, so we don't
> > have to play these ugly tricks by hand? This should not be
> > performance-critical, right?
> 
> Well, I think we'd need to add the barriers anyway.
> 
> The problem, as far as I understand it, is that the instructions can get
> reordered if there are no barriers in there.

Yes, and it doesn't help if we make usermodehelper_disabled atomic_t.
atomic_xxx() operations do not imply the memory barrier semantics.

Oleg.

