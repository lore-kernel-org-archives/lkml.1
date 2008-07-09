Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbYGIUAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbYGIUAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYGIUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:00:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbYGIUAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:00:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies (was: Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support)
Date: Wed, 9 Jul 2008 22:02:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
References: <patchbomb.1215554782@localhost> <20080709195218.GA9608@elte.hu> <200807092159.35288.rjw@sisk.pl>
In-Reply-To: <200807092159.35288.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092202.27013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of July 2008, Rafael J. Wysocki wrote:
> On Wednesday, 9 of July 2008, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > -tip testing found another PM/PM_SLEEP victim:
> > > 
> > >  arch/x86/kernel/built-in.o: In function `suspend':
> > >  apm_32.c:(.text+0xedb5): undefined reference to `save_processor_state'
> > >  apm_32.c:(.text+0xedd0): undefined reference to `restore_processor_state'
> > 
> > ah, found it - the arch-level power/ directory had a CONFIG_PM-only 
> > build dependency as well. Fixed via the commit below.
> > 
> > 	Ingo
> > 
> > ------------->
> > commit 6666fa5ebb7c78afcab540bf183c7f070c890930
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Wed Jul 9 21:45:54 2008 +0200
> > 
> >     power, xen64: fix PM_SLEEP build dependencies, #2
> >     
> >     -tip testing found another PM/PM_SLEEP victim:
> >     
> >      arch/x86/kernel/built-in.o: In function `suspend':
> >      apm_32.c:(.text+0xedb5): undefined reference to `save_processor_state'
> >      apm_32.c:(.text+0xedd0): undefined reference to `restore_processor_state'
> >     
> >     with this config:
> >     
> >      http://redhat.com/~mingo/misc/config-Wed_Jul__9_18_53_45_CEST_2008.bad
> >     
> >     the core scenario is this combination (and only this combination) of
> >     config values:
> >     
> >       # CONFIG_PM is not set
> >       CONFIG_PM_SLEEP=y
> >       CONFIG_APM=y
> >       CONFIG_PARAVIRT=y
> >       CONFIG_XEN=y
> 
> This combination actually doesn't make sense whatsoever.
> 
> PM_SLEEP depends (indirectly) on PM and the fact that it's possible to use
> a .config violating this dependency is a build system problem, really.

Your patch is correct, though. :-)

Thanks,
Rafael
