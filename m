Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYEPQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYEPQbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYEPQbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:31:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbYEPQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:31:12 -0400
Date: Fri, 16 May 2008 09:30:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown 
In-Reply-To: <16082.1210952646@vena.lwn.net>
Message-ID: <alpine.LFD.1.10.0805160925590.2941@woody.linux-foundation.org>
References: <16082.1210952646@vena.lwn.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, Jonathan Corbet wrote:
> 
> I'll put a shortlog and diffstat at the end of this message.  For
> completeness, there's also a list of files I examined and did *not* change.

May I suggest just adding a comment in those files, just saying something 
like

	/* This does not need the BKL, because .. */

where even the "because" part could be dropped when it's really obvious.

That way that "list of files I examined and did *not* change" would be 
obvious in the patch itself, and we also have some documentation that 
somebody actually looked at the path.

> Assuming nobody tells me I'm completely off-base, I guess my next step is
> to start running individual patches past maintainers.  Some of them,
> probably (I hope), will tell me that I've been wasting my time and that
> their code doesn't need the BKL.  In such cases, I'll gladly drop the
> associated patch.

Same deal - just document the fact that the BKL isn't needed.

Yeah, in the long run that kind of documentation is worthless and we may 
want to get rid of it again in a year or two, but in the short run it's a 
good idea. If only to help people who want to review your patches.

Btw, do you have gitweb running anywhere? 

		Linus
