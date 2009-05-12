Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZELASY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZELASY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZELASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:18:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbZELASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:18:13 -0400
Date: Mon, 11 May 2009 17:11:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090511171111.9d74e4c0.akpm@linux-foundation.org>
In-Reply-To: <200905120128.16780.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905120044.37342.rjw@sisk.pl>
	<20090511160704.e1fa2512.akpm@linux-foundation.org>
	<200905120128.16780.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 01:28:15 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 12 May 2009, Andrew Morton wrote:
> > On Tue, 12 May 2009 00:44:36 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Which means this patch:
> > > http://marc.info/?l=linux-kernel&m=124165031723627 (it also is my favourite
> > > one).
> > 
> > ho hum, I could live with that ;)
> > 
> > Would it make sense to turn it into something more general?  Instead of
> > "tasks_frozen/processes_are_frozen()", present it as
> > "oom_killer_disabled/oom_killer_is_disabled()"?
> > 
> > That would invite other subsystems to use it, if they want to.  Which
> > might well be a bad thing on their behalf, hard to say..
> 
> I chose the names this way because the variable is defined in the freezer code.
> 
> Alternatively, I can define one in page_alloc.c, add [disable|enable]_oom_killer()
> for manipulating it and call them from the freezer code.  Do you think that
> would be better?

The choice is:

a) put a general oom-killer interface function into the oom-killer
   code, call that from swsusp.

b) put a swsusp-specific change into the oom-killer, call that from swsusp.


>From a cleanliess POV, a) is way better.  But it does need to be a
general function!  If there's some hidden requirement which only makes
the function applicable to swsusp, such as "all tasks must be frozen" then
we'd be kidding ourselves by making it general-looking.

I have a bad feeling that after one week and 12^17 emails, we're back
to your original patch :)

