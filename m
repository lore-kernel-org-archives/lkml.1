Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZLHPfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZLHPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932116AbZLHPft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:35:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067AbZLHPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:35:48 -0500
Date: Tue, 8 Dec 2009 07:35:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <200912081323.50606.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912080728590.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912072225390.4179-100000@netrider.rowland.org> <200912081323.50606.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> 
> The wait queue plus the op_complete flag combo plays the role of the locking
> in the Linus' picture

Please just use the lock. Don't make up your own locking crap. Really. 

Your patch is horrible. Exactly because your locking is horribly 
mis-designed. You can't say things are complete from an interrupt, for 
example, since you made it some random bitfield, which has unknown 
characteristics (ie non-atomic read-modify-write etc).

The fact is, any time anybody makes up a new locking mechanism, THEY 
ALWAYS GET IT WRONG. Don't do it.

I suggested using the rwsem locking for a good reason. It made sense. It 
was simpler. Just do it that way, stop making up crap.

		Linus
