Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXFYWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXFYWUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbXFYWUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:20:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXFYWUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:20:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Date: Tue, 26 Jun 2007 00:27:01 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
References: <200706252352.24137.rjw@sisk.pl> <20070625215527.GE2051@elf.ucw.cz>
In-Reply-To: <20070625215527.GE2051@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260027.02396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 June 2007 23:55, Pavel Machek wrote:
> Hi!
> 
> > [I hope the ACKs still apply.]
> 
> Uhuh, not 100% sure.
> 
> > +static int usermodehelper_disabled;
> > +
> 
> 
> ...
> 
> >  	case PM_HIBERNATION_PREPARE:
> >  	case PM_SUSPEND_PREPARE:
> >  		usermodehelper_disabled = 1;
> > -		return NOTIFY_OK;
> > +		smp_mb();
> 
> usermodehelper_disabled should be atomic variable, too, so we don't
> have to play these ugly tricks by hand? This should not be
> performance-critical, right?

Well, I think we'd need to add the barriers anyway.

The problem, as far as I understand it, is that the instructions can get
reordered if there are no barriers in there.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
