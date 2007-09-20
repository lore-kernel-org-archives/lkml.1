Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXITAHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXITAHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXITAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:07:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbXITAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:07:08 -0400
Date: Wed, 19 Sep 2007 17:06:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Chuck Ebbert <cebbert@redhat.com>, tilman@imap.cc,
       linux-kernel@vger.kernel.org, gregkh@suse.de, a.zummo@towertech.it
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070919170604.f7e82f19.akpm@linux-foundation.org>
In-Reply-To: <20070919234448.8E87D2319AA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46F1AA6E.1030708@imap.cc>
	<20070919162438.7264f06c.akpm@linux-foundation.org>
	<20070919234448.8E87D2319AA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 16:44:48 -0700
David Brownell <david-b@pacbell.net> wrote:

> > > <4>[   21.211942] Duplicate file names "rtc" detected
> >
> > Nah, that's an rtc-specific problem.
> 
> RTC-related ... but it's a procfs bug, since it's procfs which doesn't
> even bother to check for duplicate names before it registers files.

So you keep on claiming, but I don't think I've yet seen a description of
the *reason* why two copies of this file are being created, and a
description of why that is an OK thing for the kernel to be doing.

> > From: Chuck Ebbert <cebbert@redhat.com>
> >
> > AFAICT the rtc problem is caused by misconfiguration: both the new
> > and old rtc driver have been built and they are both trying to load.
> 
> That _shouldn't_ be a problem at all; only one of them should be
> able to bind to that hardware.
> 
> The only problem I see in these messages is that procfs bug.
> 

It's not obvious that this is only a procfs bug.  If some part of the
kernel tries to add a procfs file which is already there, that's often a
bug in the caller.

Yes, procfs should have been checking for this.  But it is too late now for
us to just fail out of the procfs registration code.  Because this can
cause previously buggy-but-works-ok code to now fail completely.

So I think the best we can do now is to retain the runtime warning and to
continue to "succeed" and to identify all the problematic codesites and to
either fix them or to convince ourselves that they really are working as
intended. 
