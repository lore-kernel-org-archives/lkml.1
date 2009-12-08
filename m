Return-Path: <linux-kernel-owner+w=401wt.eu-S966479AbZLHVkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966479AbZLHVkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966442AbZLHVkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:40:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44424 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966254AbZLHVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:40:04 -0500
Date: Tue, 8 Dec 2009 16:40:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <200912082152.21910.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912081633540.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:

> BTW, is there a good reason why completion_done() doesn't use spin_lock_irqsave
> and spin_unlock_irqrestore?  complete() and complete_all() use them, so why not
> here?

And likewise in try_wait_for_completion().  It looks like a bug.  Maybe 
these routines were not intended to be called with interrupts disabled, 
but that requirement doesn't seem to be documented.  And it isn't a 
natural requirement anyway.

Alan Stern

