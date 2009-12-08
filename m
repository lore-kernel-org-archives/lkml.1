Return-Path: <linux-kernel-owner+w=401wt.eu-S966270AbZLHVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966270AbZLHVcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965733AbZLHVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:32:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965709AbZLHVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:32:46 -0500
Date: Tue, 8 Dec 2009 16:32:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <alpine.LFD.2.00.0912081242550.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912081626400.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Linus Torvalds wrote:

> > No, that's not needed.  Unlike reads, writes can't move in front of
> > data or control dependencies.  Or so I've been lead to believe...
> 
> Sure they can. Control dependencies are trivial - it's called "branch 
> prediction", and everybody does it, and data dependencies don't exist on 
> many CPU architectures (even to the point of reading through a pointer 
> that you loaded).

Wait a second.  Are you saying that with code like this:

	if (x == 1)
		y = 5;

the CPU may write to y before it has finished reading the value of x?  
And this write is visible to other CPUs, so that if x was initially 0
and a second CPU sets x to 1, the second CPU may see y == 5 before it
executes the write to x (whatever that may mean)?

Alan Stern

