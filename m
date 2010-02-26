Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab0BZOvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:51:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44799 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907Ab0BZOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:51:09 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
From: Andi Kleen <andi@firstfloor.org>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
	<20090803112220.GA22936@elte.hu>
	<20090803072522.1d90f15c@infradead.org>
	<20090804201109.GA21386@elte.hu> <20090805123501.GF14610@erda.amd.com>
	<84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com>
	<20090806105134.GD11236__37984.4768475325$1249556453$gmane$org@elte.hu>
Date: Fri, 26 Feb 2010 15:51:04 +0100
In-Reply-To: <20090806105134.GD11236__37984.4768475325$1249556453$gmane$org@elte.hu> (Ingo Molnar's message of "Thu, 6 Aug 2009 12:51:34 +0200")
Message-ID: <87ocjcqcdj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> As you note it below, in terms of development it's quite a 
> distraction to have active development in both facilities, when 
> oprofile is arguably on the to-be-obsoleted side of the equation. 

I don't see how it is distracting (for whom anyways?) at all to develop both.
It's just like two ethernet/SCSI/... drivers being developed in parallel
by different people. Happens all the time. The Linux development model
can handle it.

That said the biggest problem with oprofile right now that the
new buffer it's using is quite a lot less reliable and drops
events left and right on any non trivial load. That makes
oprofile very unreliable, especially in call graph mode.

So if there was a "legacy oprofile" it would be better to have
one that does not use the ring buffer, but using the old buffer which
at least worked. This would drop IBS support unfortunately,
but perhaps that could be just done in perf only (depends on 
how big the IBS user base for current oprofile is)

> And yes, AFAIK oprofile user-space is pretty much the only 
> user-space app that relies on the oprofile ABI - at least in the OSS 
> space. Robert, is there perhaps some bin-only oprofile based tool 
> that you implied before? Which one is it?

There are multiple, e.g. Zoom or the old HP tool whose name
escapes me now. Also I think there are a couple of minor forks around
in various distro trees.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
