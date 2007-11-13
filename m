Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXKMHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXKMHrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXKMHrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:47:09 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50276 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXKMHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:47:08 -0500
Date: Tue, 13 Nov 2007 13:29:46 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Message-ID: <20071113075946.GA14731@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <47394B84.8030008@linux.vnet.ibm.com> <6599ad830711122310nf7530cfs5ef1fea061b1252c@mail.gmail.com> <47395277.1060006@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47395277.1060006@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 12:59:59PM +0530, Balbir Singh wrote:
> Paul Menage wrote:
> > On Nov 12, 2007 11:00 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >> Right now, one of the limitations of the CPU controller is that
> >> the moment you create another control group, the bandwidth gets
> >> divided by the default number of shares. We can't create groups
> >> just for monitoring.
> > 
> > Could we get around this with, say, a flag that always treats a CFS
> > schedulable entity as having a weight equal to the number of runnable
> > tasks in it? So CPU bandwidth would be shared between groups in
> > proportion to the number of runnable tasks, which would distribute the
> > cycles approximately equivalently to them all being separate
> > schedulable entities.
> > 
> 
> I think it's a good hack, but not sure about the complexity to implement
> the code.

I agree that it would be adding unnecessary complexity, just to meet the
accounting needs.

Thinking of it more, this requirement to "group tasks for only accounting
purpose" may be required for other resources (mem, io, network etc) as well?
Should we have a generic accounting controller which can provide these
various resource usgae stats for a group (cpu, mem etc) by iterating thr' the 
task list for the group and summing up the corresponding stats already present 
in task structure?

-- 
Regards,
vatsa
