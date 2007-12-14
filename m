Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbXLNUF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbXLNUF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXLNUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:05:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXLNUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:05:49 -0500
Date: Fri, 14 Dec 2007 21:06:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214200605.GA17424@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro> <20071214122048.GA12550@one.firstfloor.org> <20071214180119.4c492f6c@linux360.ro> <alpine.LFD.0.99999.0712141835510.3668@localhost.localdomain> <20071214181233.GB16351@one.firstfloor.org> <alpine.LFD.0.99999.0712142053400.3668@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.99999.0712142053400.3668@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, that would interfere with the acpi-idle code.

How so? idle notifiers should work for acpi idle too.

> Anyway the idle notifiers is a pretty artificial interface which is on
> my get rid of it list anyway.

The original use cases were: 
- Accounting for idle time with stopped counters in oprofile and eliminate
the need for idle=poll.
That never was implemented unfortunately but would be still a worthy
feature I think.
- Perfmon for similar uses.
- noidletick -- my original noidletick implementation used the idle
notifiers similar to the s390 implementation. Obsolete now. 

Right now it is used for the machine check early notification, but I never
liked that (imho it just "fixes" a non problem only relevant 
in non realistic testing situations) and it would be fine to drop that one 
I think.  In fact I already made it a config in the patchkit to use the 64bit
mce code on 32bit too.

-Andi

