Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbXJDVej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbXJDVej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXJDVeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:34:31 -0400
Received: from mx1.lost-oasis.net ([212.85.153.8]:35154 "EHLO
	mx1.lost-oasis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXJDVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:34:30 -0400
X-Greylist: delayed 2978 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 17:34:30 EDT
Date: Thu, 4 Oct 2007 22:44:43 +0200
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
Message-ID: <20071004204443.GA28483@bigip.bigip.mine.nu>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ollie Wild <aaw@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu> <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
	3:{EoxBR
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for getting back to me.

On Thu, Oct 04, 2007 at 10:27:52AM -0700, Linus Torvalds wrote:
> What does your "ulimit -s" say?

That's actually the first thing I checked.

mchouque - /usr/src/kernel/linux %ulimit -s
unlimited

And for the record, ulimit -a yields:
-t: cpu time (seconds)         unlimited
-f: file size (blocks)         unlimited
-d: data seg size (kbytes)     unlimited
-s: stack size (kbytes)        unlimited
-c: core file size (blocks)    0
-m: resident set size (kbytes) unlimited
-u: processes                  16375
-n: file descriptors           1024
-l: locked-in-memory size (kb) 32
-v: address space (kb)         unlimited
-x: file locks                 unlimited
-i: pending signals            16375
-q: bytes in POSIX msg queues  819200
-N 13:                         0
-N 14:                         0


> I suspect that you might hit the code that limits execve() arguments to 
> one quarter of the maximum stack size.
> 
> We could change that from 25% to something else (half? three quarters?), 
> but if you really are hitting that limit, it sounds like you may have a 
> really small stack size to begin with (ie if 25% is smaller than the old 
> argument size limit of 128kB, you're running with a stack limit of less 
> than half a meg, which sounds pretty dang small).
> 
> So I'd like to verify that the stack limit really is the issue, and not 
> something else.

Anything else you'd like me to try?

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
