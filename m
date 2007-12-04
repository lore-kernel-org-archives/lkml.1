Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbXLDAbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbXLDAbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 19:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXLDAax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 19:30:53 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4874 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXLDAax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 19:30:53 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Mark Lord" <lkml@rtr.ca>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Chris Friesen" <cfriesen@nortel.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 16:30:26 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEINIJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071203220559.GA11906@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 03 Dec 2007 16:31:34 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 03 Dec 2007 16:31:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> * Mark Lord <lkml@rtr.ca> wrote:

> > Ack.  And what of the suggestion to try to ensure that a yielding task
> > simply not end up as the very next one chosen to run?  Maybe by
> > swapping it with another (adjacent?) task in the tree if it comes out
> > on top again?

> we did that too for quite some time in CFS - it was found to be "not
> agressive enough" by some folks and "too agressive" by others. Then when
> people started bickering over this we added these two simple corner
> cases - switchable via a flag. (minimum agression and maximum agression)

They are both correct. It is not agressive enough if there are tasks other
than those two that are at the same static priority level and ready to run.
It is too agressive if the task it is swapped with is at a lower static
priority level.

Perhaps it might be possible to scan for the task at the same static
priority level that is ready-to-run but last in line among other
ready-to-run tasks and put it after that task? I think that's about as close
as we can get to the POSIX-specified behavior.

> > Thanks Ingo -- I *really* like this scheduler!

Just in case this isn't clear, I like CFS too and sincerely appreciate the
work Ingo, Con, and others have done on it.

DS


