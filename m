Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYJVOg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYJVOg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYJVOgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:36:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:56010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYJVOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:36:13 -0400
Date: Wed, 22 Oct 2008 07:36:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: sched: deep power-saving states
Message-ID: <20081022073616.5eb150fa@infradead.org>
In-Reply-To: <48FF3829.8040704@novell.com>
References: <48FF2DDC.5010600@gmail.com>
	<20081022064738.05818670@infradead.org>
	<48FF3321.4060809@novell.com>
	<20081022070701.567f1c9a@infradead.org>
	<48FF3829.8040704@novell.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 10:26:49 -0400
Gregory Haskins <ghaskins@novell.com> wrote:
steps, so it'll be
> > faster) 
> 
> [Adding Peter Zijlstra to the thread]
> 
> Ah, yes of course!   That makes sense.  So I have to admit I am fairly
> ignorant of the ACPI C-state stuff, so I just read up on it.  In the
> context of what you said, it makes perfect sense to me now.
> 
> IIUC, the OS selects which C-state it will enter at idle points based
> on some internal criteria (TBD).  All we have to do is remap the
> cpupri "IDLE" state to something like IDLE-C1, IDLE-C2, ..., IDLE-Cn
> and have the cpupri map get updated coincident with the pm_idle()
> call.  Then the scheduler will naturally favor cores that are in
> lighter sleep over cores in deep sleep.
> 
> I am not sure if this is exactly what you were getting at during the
> conf, since it doesnt really consider deep-sleep latency times
> directly.  But I think this is a step in the right direction.

it for sure is a step in the right direction.
the actual exit costs are an optional parameter in this sense,
the steps between C states are non-linear (more like exponential)
so knowing the actual numbers could be used. but even if you don't
use it, it still makes sense and is a very good first order behavior.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
