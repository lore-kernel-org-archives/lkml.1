Return-Path: <linux-kernel-owner+w=401wt.eu-S934306AbZLFVqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306AbZLFVqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934238AbZLFVqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:46:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49162 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934236AbZLFVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:46:12 -0500
Date: Sun, 6 Dec 2009 16:46:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <20091206131702.7d6cdc57@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0912061636170.9457-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Arjan van de Ven wrote:

> > Arjan, can you try testing the USB timings again with the patch below 
> > (for vanilla 2.6.32)?
> > 
> > Fair warning: I just composed this and haven't tried it out myself.
> 
> unfortunately it does not make a difference that I can notice in the
> graphs.
> 
> http://www.fenrus.org/graphs/resume2.svg

Disappointing...

> the resume problem seems to be that we resume all the hubs sequentially,
> much like we used to discover them sequentially during boot....

But the patch should have reduced the time required to resume each 
non-root hub.  So the fact that they go sequentially shouldn't matter 
as much.

For root hubs the patch won't help.  Their delays can't be reduced.

> I do not know how much I'm asking for, but would it be sensible to do a
> similar thing for hub resume as we did for boot? eg start resuming them
> all at the same time, so that the mandatory delays of these hubs will
> overlap ?

For one thing, there shouldn't be any mandatory delays for non-root
hubs during resume-from-RAM (although this depends to some extent on
your system firmware -- and it probably helps to have USB-2.0 hubs
rather than USB-1.1).

More importantly, what you're asking is impossible given the way the PM
core is structured.  The hub-resume routine can't return early because
then it wouldn't be possible to resume devices plugged into that hub.

(Ironically, your request is essentially what Rafael was trying to 
accomplish in the patches that provoked this email conversation.)

Guess I'll just have to try out your timing log addition for myself and
see what's going on...

Alan Stern

