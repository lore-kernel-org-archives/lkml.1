Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbXKMHaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbXKMHaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbXKMHaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:30:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34372 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXKMHaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:30:10 -0500
Message-ID: <47395277.1060006@linux.vnet.ibm.com>
Date: Tue, 13 Nov 2007 12:59:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: containers@lists.linux-foundation.org, vatsa@linux.vnet.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Revert for cgroups CPU accounting subsystem patch
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com> <20071113060038.GC3359@linux.vnet.ibm.com> <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com> <47394B84.8030008@linux.vnet.ibm.com> <6599ad830711122310nf7530cfs5ef1fea061b1252c@mail.gmail.com>
In-Reply-To: <6599ad830711122310nf7530cfs5ef1fea061b1252c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Nov 12, 2007 11:00 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Right now, one of the limitations of the CPU controller is that
>> the moment you create another control group, the bandwidth gets
>> divided by the default number of shares. We can't create groups
>> just for monitoring.
> 
> Could we get around this with, say, a flag that always treats a CFS
> schedulable entity as having a weight equal to the number of runnable
> tasks in it? So CPU bandwidth would be shared between groups in
> proportion to the number of runnable tasks, which would distribute the
> cycles approximately equivalently to them all being separate
> schedulable entities.
> 

I think it's a good hack, but not sure about the complexity to implement
the code. I worry that if the number of tasks increase (say run into
thousands for one or more groups and a few groups have just a few
tasks), we'll lose out on accuracy.

>> cpu_acct fills this gap.
> 
> Agreed, but not in the right way IMO.
> 

I think we already have the code, we need to make it more useful and
reusable.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
