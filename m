Return-Path: <linux-kernel-owner+w=401wt.eu-S933128AbZHDVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbZHDVsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbZHDVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:48:45 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:61266 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbZHDVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:48:44 -0400
Date: Tue, 4 Aug 2009 22:48:15 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Giuseppe CAVALLARO <peppe.cavallaro@st.com>, ltt-dev@lists.casi.polymtl.ca,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org
Subject: Re: sh: Add ftrace syscall tracing support (was: Re: [ltt-dev]
	[PATCH] sh: added LTT_DUMP_TABLES support)
Message-ID: <20090804214815.GC4084@console-pimps.org>
References: <1249040606-15402-1-git-send-email-peppe.cavallaro@st.com> <20090731155048.GD8847@Krystal> <4A77F585.2070508@st.com> <20090804133515.GB23807@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804133515.GB23807@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 09:35:15AM -0400, Mathieu Desnoyers wrote:
> * Giuseppe CAVALLARO (peppe.cavallaro@st.com) wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Hi Mathieu,
> > 
> > Mathieu Desnoyers wrote:
> > > So now we only need to fix entry-common.S to get everything working.
> > 
> > I've just noticed that this has been already done:
> > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Flethal%2Fsh-2.6.git;a=commitdiff_plain;h=c652d780c9cf7f860141de232b37160fe013feca;hp=c1340c053be7a43d837a3acb352d5008be865a55
> > I think it will be necessary to to re-add the _TIF_KERNEL_TRACE against
> > this modifications, only.
> > 
> 
> Hrm, I don't like the approach taken there. It extends the bitmasks for
> _TIF_WORK_SYSCALL_MASK and _TIF_ALLWORK_MASK beyond 8 bits, and adds a &
> 0xff in the assembly whenever needed. This begs for a bug to be
> introduced.
> 
> If we need something like that on SH, we should probably declare a 8-bit
> only bitmask for those assembly sites which does not need the
> FTRACE_SYSCALL thread flag, and another mask for sites which need to
> test the 2 bytes.
> 

If I remember correctly, I originally split TIF_WORK_SYSCALL_MASK into a
high 8-bit and low 8-bit chunks. However, I think I remember Paul saying
that wasn't the best way to do it.

I've no issue with doing it either way.
