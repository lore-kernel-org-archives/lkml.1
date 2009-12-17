Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbZLQTCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbZLQTCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZLQTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:02:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58439 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZLQTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:02:23 -0500
To: John Reiser <jreiser@bitwagon.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: tracing: gcc for x86 calling mcount with -fomit-frame-pointer
From: Andi Kleen <andi@firstfloor.org>
References: <4B2A689D.2050202@bitwagon.com>
Date: Thu, 17 Dec 2009 20:02:19 +0100
In-Reply-To: <4B2A689D.2050202@bitwagon.com> (John Reiser's message of "Thu, 17 Dec 2009 09:21:33 -0800")
Message-ID: <87vdg5s9tw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Reiser <jreiser@bitwagon.com> writes:

> On x86 and x86_64, current "gcc -pg -fomit-frame-pointer" is not allowed.
> This experimental patch against:
>   http://mirrors.kernel.org/fedora/releases/12/Fedora/source/SRPMS/gcc-4.4.2-7.fc12.src.rpm
> allows such a combination, via the  command line options:
>   gcc --profile-before-prolog -fomit-frame-pointer
> This turns on profiling (as if -pg), moves the "call mcount" to be the
> very first instruction of a profiled routine, and omits the frame pointer
> (unless some condition other than profiling requires a frame pointer.)
> Placing the "call mcount" first, before any other code, has some advantages.
> For instance, a postprocessor easily can modify a CALL whose destination
> is known, to skip past the "call mcount" at the entry point.
>
> The current glibc implementation of mcount relies on a frame pointer.
> At least one recent change to Linux kernel traceback for tracing also relies
> on a frame pointer.  So still there are conflicts, but they are different.

I submitted a similar patch for all of this some time to gcc,
and also resubmitted it recently. It doesn't seem to be very high
up the priority list of the gcc people.

It missed their "merge window" (although lots of other changes went in),
but they told me it's queued in some way for the next stage 1.
We'll see if that's true or not.

I also have a glibc patch for this.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
