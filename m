Return-Path: <linux-kernel-owner+w=401wt.eu-S935189AbXGQWif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbXGQWif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbXGQWi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:38:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33661 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755397AbXGQWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:38:26 -0400
Date: Tue, 17 Jul 2007 18:38:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: david@lang.hm
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0707171835560.8690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 david@lang.hm wrote:

> > But what about the freezer?  The original reason for using kexec was to
> > avoid the need for the freezer.  With no freezer, while the original
> > kernel is busy powering down its devices, user tasks will be free to
> > carry out I/O -- which will make the memory snapshot inconsistent with
> > the on-disk data structures.
> 
> no, user tasks just don't get scheduled during shutdown.

But a user task may be holding a lock which is needed for putting some 
device into low-power mode.  It can't release that lock if it doesn't 
get scheduled.

Alan Stern

