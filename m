Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXKZS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXKZS07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXKZS0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:26:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbXKZS0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:26:48 -0500
Date: Mon, 26 Nov 2007 10:25:33 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net>
In-Reply-To: <200711261228.15155.rusty@rustcorp.com.au>
References: <20071122343.446909000@suse.de>
	<adatznarrzc.fsf@cisco.com>
	<200711261228.15155.rusty@rustcorp.com.au>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 12:28:14 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 26 November 2007 07:27:03 Roland Dreier wrote:
> >  > This patch allows to export symbols only for specific modules by
> >  > introducing symbol name spaces. A module name space has a white
> >  > list of modules that are allowed to import symbols for it; all others
> >  > can't use the symbols.
> >  >
> >  > It adds two new macros:
> >  >
> >  > MODULE_NAMESPACE_ALLOW(namespace, module);
> >
> > I definitely like the idea of organizing exported symbols into
> > namespaces.  However, I feel like it would make more sense to have
> > something like
> >
> > MODULE_NAMESPACE_IMPORT(namespace);
> 
> Except C doesn't have namespaces and this mechanism doesn't create them.  So 
> this is just complete and utter makework; as I said before, noone's going to 
> confuse all those udp_* functions if they're not in the udp namespace.
> 
> For better or worse, this is not C++.
> 


Agreed. On first glance, I was intrigued but:

1) Why is everyone so concerned that export symbol space is large?
	- does it cost cpu or running memory?
	- does it cause bugs?
	- or are you just worried about "evil modules"?

2) These aren't real namespaces
	- all global names still have to be unique
	- still have to handle the "non-modular build" namespace conflicts
	- there isn't a big problem with conflicting symbols today.

So why bother adding complexity.
-- 
Stephen Hemminger <shemminger@linux-foundation.org>
