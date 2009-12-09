Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZLIW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZLIW1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbZLIW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:27:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36358 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758120AbZLIW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:27:14 -0500
Date: Wed, 9 Dec 2009 17:27:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <200912092256.45872.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912091722310.2672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Rafael J. Wysocki wrote:

> > I don't like that because it introduces "artificial" dependencies: It 
> > makes B depend on all the preceding synchronous suspends, even totally 
> > unrelated ones.  But yes, it would work.
> 
> Well, unfortunately, it wouldn't, because (at least in the context of my last
> patch) the core would release the rwsems as soon as your suspend had
> returned.  So you'd have to make your suspend wait for the async thread and
> that would make it pointless.  So scratch that, it wasn't a good idea at all.
> 
> This leaves us with basically two options, where the first one is to use
> rwsems in a way that you've proposed (with iterating over children), and the
> second one is to use completions.  In my opinion rwsems don't give us any
> advantage in this case, so I'd very much prefer to use completions.

If you really want to add support for async suspend constraints, then 
completions are clearer than rwsems.  If you don't care (and it's 
unlikely that anyone will need them in the near future) then you might 
as well stick with the current rwsem implementation and avoid iterating 
over children.

Alan Stern

