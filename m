Return-Path: <linux-kernel-owner+w=401wt.eu-S1764415AbXKQSwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764415AbXKQSwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760175AbXKQSv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:51:59 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37944 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbXKQSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:51:58 -0500
Date: Sat, 17 Nov 2007 13:51:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH v3 10/17] Remove some CFS specific code from the wakeup
 path of RT tasks
In-Reply-To: <473EE01F.BA47.005A.0@novell.com>
Message-ID: <Pine.LNX.4.58.0711171350510.12054@gandalf.stny.rr.com>
References: <20071117062104.177779113@goodmis.org> <20071117062404.672976284@goodmis.org>
 <473EE01F.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 17 Nov 2007, Gregory Haskins wrote:

> >>> On Sat, Nov 17, 2007 at  1:21 AM, in message
> <20071117062404.672976284@goodmis.org>, Steven Rostedt <rostedt@goodmis.org>
> wrote:
>
> > +	 */
> > +	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
> > +		return cpu;
> > +
> > +	for_each_domain(cpu, sd) {
> > +		if (sd->flags & SD_WAKE_IDLE) {
> > +			cpus_and(tmp, sd->span, p->cpus_allowed);
> > +			for_each_cpu_mask(i, tmp) {
> > +				if (idle_cpu(i))
> > +					return i;
>                                                                         ^^^^^^^^^^^^^^^^
>
> Looks like some stuff that was added in 24 was inadvertently lost in the move when you merged the patches up from 23.1-rt11.  The attached patch is updated to move the new logic as well.
>

Doh!  Good catch. Will rework on Monday.

-- Steve

