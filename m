Return-Path: <linux-kernel-owner+w=401wt.eu-S1765351AbXFEQtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765351AbXFEQtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764762AbXFEQtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:49:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20996 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbXFEQtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:49:05 -0400
Date: Tue, 5 Jun 2007 09:48:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: Oliver Neukum <oneukum@suse.de>, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ] Re: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked
 region
Message-Id: <20070605094835.5ada50da.randy.dunlap@oracle.com>
In-Reply-To: <87ejkqe51t.fsf@wanadoo.fr>
References: <87odjvu1on.fsf@wanadoo.fr>
	<20070604210018.0eaa20a0.akpm@linux-foundation.org>
	<87k5uimzkh.fsf@wanadoo.fr>
	<200706051333.12219.oneukum@suse.de>
	<87ejkqe51t.fsf@wanadoo.fr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 18:31:42 +0200 Yoann Padioleau wrote:

> Oliver Neukum <oneukum@suse.de> writes:
> 
> > Am Dienstag, 5. Juni 2007 13:05 schrieb Yoann Padioleau:
> >> Ok. Do you have a preference on the format ?  a <file>:<line> format  ?
> >> 
> >> Is there a place that gathered all those implicit programming rules 
> >> (that copy_from_user must not be called inside a spinlock, etc) so that
> >> I can translate them in a script for our tool.
> >
> > How much C does your tool understand? 
> 
> The tool understands almost all the C language but the analysis we do
> for the moment are intra-procedural so when we look for 
>  spin_lock();
>  ...
>  copy_from_user();
> 
> it can detect cases and code paths only when the two function calls
> are in the same function. It could be extended but it would require to
> do a full analysis of the kernel source. Maybe if some functions of
> the library have an attribute in their prototype in the .h such as
> 
>  __might_sleep copy_from_user(); 
> 
> it could help.
> 
> > You might basically
> > test for code paths that go to "might_sleep()"
> 
> Ok, thanks. If you know other implicit programming rules,
> I would be glad to know them, or if you know places
> where thus rules are written.
> 
> 
> BTW at one point I think the Linux community were using advanced
> static analysis tools such as the one made by Dawson Engler (now
> Coverity). The communitty have stopped using such tools ? Isn't the
> role of sparse to detect bugs such as the dangerous copy_from_user()
> inside spinlocked region ?
> 

There are a few people who have registered for access to the
Coverity database and occasionally go thru it looking for bugs
and then posting fixes.

sparse can check for unbalanced locking, but it needs annotations
for those AFAIK.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
