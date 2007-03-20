Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXCTV0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXCTV0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXCTV0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:26:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55045 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXCTV0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:26:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Date: Tue, 20 Mar 2007 22:18:16 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703122214.02657.rjw@sisk.pl> <200703122219.21171.rjw@sisk.pl> <20070319173127.72c3419d.akpm@linux-foundation.org>
In-Reply-To: <20070319173127.72c3419d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202218.16820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 01:31, Andrew Morton wrote:
> On Mon, 12 Mar 2007 22:19:20 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Make swsusp use memory bitmaps instead of page flags for marking 'nosave' and
> > free pages.  This allows us to 'recycle' two page flags that can be used for other
> > purposes.  Also, the memory needed to store the bitmaps is allocated when
> > necessary (ie. before the suspend) and freed after the resume which is more
> > reasonable.
> > 
> > The patch is designed to minimize the amount of changes and there are some nice
> > simplifications and optimizations possible on top of it.  I am going to
> > implement them separately in the future.
> 
> Blows up with ia64 allmodconfig due to CONFIG_PM=y, CONFIG_SOFTWARE_SUSPEND=n:
> 
> kernel/power/main.c:223: error: redefinition of 'software_suspend'
> include/linux/suspend.h:46: error: previous definition of 'software_suspend' was here
> 
> I had a look at fixing it, but it's unobvious why we're compiling most of
> kernel/power/main.c when CONFIG_SOFTWARE_SUSPEND=n so I'll send this series
> back for repair please.

Well, it was sufficient to add #ifdef CONFIG_SOFTWARE_SUSPEND around the
definition of software_suspend() in kernel/power/main.c.

The following series of patches compiles with CONFIG_SOFTWARE_SUSPEND=n too.

Greetings,
Rafael

