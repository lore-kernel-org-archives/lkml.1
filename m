Return-Path: <linux-kernel-owner+w=401wt.eu-S941220AbXGTQau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941220AbXGTQau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938427AbXGTQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:30:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936942AbXGTQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:30:41 -0400
Date: Fri, 20 Jul 2007 09:30:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: drivers/base/core.c broken for non-CONFIG_HOTPLUG
Message-Id: <20070720093018.8260fc0c.akpm@linux-foundation.org>
In-Reply-To: <1184933179.3545.12.camel@lov.localdomain>
References: <20070720070106.GH1678@pengutronix.de>
	<20070720005958.47cd7c9c.akpm@linux-foundation.org>
	<1184933179.3545.12.camel@lov.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 14:06:19 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, 2007-07-20 at 00:59 -0700, Andrew Morton wrote:
> > On Fri, 20 Jul 2007 09:01:06 +0200 Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> > 
> > > You add and use
> > > 
> > > 	extern const char *kobject_actions[];
> > 
> > Added it in a .c file, too.  Even checkpatch.pl knows that
> > was wrong.
> 
> The kernel is doing that all over the place for global symbols that are
> not meant to be used out of a "private" context or where a "private"
> header file of a subsystem doesn't exist.

Whatever the reason, it's still wrong, because the problem remains: lack of
typechecking between the definition and its users.

It's defensible in one situation: where the definition is in assembly
language.  And even then the symbol can be declared in a header, if only
because a second user may be added.

> I can change that, if this isn't the way to do it?

Please.  Let's find a reasonably-relevant header for it.  If there isn't
one, let's add it; there are quite possibly other things which should be in
that header so choose with care, with that possibility in mind.
