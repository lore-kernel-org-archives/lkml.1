Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYGIUbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYGIUbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYGIUbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:31:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbYGIUbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:31:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
Date: Wed, 9 Jul 2008 22:33:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
References: <patchbomb.1215554782@localhost> <200807092217.53222.rjw@sisk.pl> <48751E34.3060100@goop.org>
In-Reply-To: <48751E34.3060100@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092233.08930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Jeremy Fitzhardinge wrote:
> Rafael J. Wysocki wrote:
> > On Wednesday, 9 of July 2008, Ingo Molnar wrote:
> >   
> >> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >>     
> >>>> This combination actually doesn't make sense whatsoever.
> >>>>
> >>>> PM_SLEEP depends (indirectly) on PM and the fact that it's possible 
> >>>> to use a .config violating this dependency is a build system 
> >>>> problem, really.
> >>>>         
> >>> Your patch is correct, though. :-)
> >>>       
> >> yes, that combination doesnt make sense in -git, but tip/xen64 tries the 
> >> !PM && PM_SLEEP combination - see the patch below.
> >>     
> >
> > It shouldn't.  There are many things compiled if PM is set that PM_SLEEP
> > depends on, most importantly ->suspend() and ->resume() callbacks of almost
> > all drivers.  Ignoring this dependency is asking for trouble.
> >   
> 
> Doesn't that mean that PM_SLEEP should depend on PM?

It does.  And it depends on PM, because HIBERNATION and SUSPEND both depend
on PM.

> > I don't like this.
> >
> > I'll have a look at the remaining related patches and see what can be done.
> >
> > Jeremy, what exactly do you need the !PM && PM_SLEEP combination for, BTW?
> >   
> 
> See drivers/xen/manage.c.  On the Xen save/restore path, I call 
> device_(suspend|resume|power_down|power_up)(), primarily to get the 
> system timers into a good state after the machine has been away for a 
> while.  Xen doesn't have a general dependency on the rest of the PM 
> infrastructure.

Well, device drivers' ->suspend() and ->resume() callbacks generally depend on
PM instead of PM_SLEEP (historical thing), so in fact you need the dependency
on PM.

In future we may be able to clean that up, but only after the new
suspend/hibernation framework reaches the mainline and drivers start to use it.

Thanks,
Rafael
