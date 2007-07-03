Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXGCQDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXGCQDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXGCQDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:03:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49719 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755342AbXGCQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:03:34 -0400
Date: Tue, 3 Jul 2007 12:03:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031200240.3936-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> a screaming nightmare - either the suspend fails because syslog (for 
> instance) can't be frozen, or the machine deadlocks for some other 
> reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> could do what we do for suspend to RAM on other platforms (PPC and APM) 
> and just not use the freezer.

Quite apart from the sync() matter, _any_ synchronous call to a FUSE 
filesystem during STR will cause trouble.  Even if the user task 
implementing the filesystem isn't frozen, when it tries to carry out 
some I/O to a suspended device it will either:

	block until the system wakes up, or

	cause the suspend to abort.

Neither outcome is desirable.

Alan Stern

