Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbXJRTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbXJRTZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbXJRTZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:25:25 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1717 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382AbXJRTZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:25:23 -0400
Date: Thu, 18 Oct 2007 20:25:21 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
Message-ID: <20071018192521.GC21136@shadowen.org>
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018111352.GA17039@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 01:13:52PM +0200, Ingo Molnar wrote:
> 
> latest checkpatch.pl works really well on sched.c.
> 
> there's only one problem left, this bogus false positive warning 
> reappeared:
> 
>   WARNING: braces {} are not necessary for single statement blocks
>   #5710: FILE: sched.c:5710:
>   +       if (parent->groups == parent->groups->next) {
>   +               pflags &= ~(SD_LOAD_BALANCE |
>   +                               SD_BALANCE_NEWIDLE |
>   +                               SD_BALANCE_FORK |
>   +                               SD_BALANCE_EXEC |
>   +                               SD_SHARE_CPUPOWER |
>   +                               SD_SHARE_PKG_RESOURCES);
>   +       }
> 
> (there's another place in sched.c that trips this up too.)

It actually never went away, some of the wronger reports went away such
as counting a commented statement as a single statement.  The check for
length didn't make the cut for 0.11, as I was still thinking about
whether we wanted a subjective check on statements over and above the
"real" check for lines.

> i think it has been pointed out numerous times that it is perfectly fine 
> to use curly braces for multi-line single-statement blocks. That 
> includes simple cases like this too:
> 
> 	if (x) {
> 		/* do y() */
> 		y();
> 	}

Yes and the comment in there actually counts as a statement for counting
statement purposes.  

The plan is to move to counting lines and only winge on exactly one
line.  I have half a mind to make a subjective check on statements and a
full check on lines.  But probabally it will just move to lines.

> it's perfectly legitimate, in fact more robust. So if checkpatch.pl 
> wants to make any noise about such constructs it should warn about the 
> _lack_ of curly braces in every multi-line condition block _except_ the 
> only safe single-line statement:
> 
> 	if (x)
> 		y();

Indeed.  We should probabally do more on the indentation checks in
general.  The current direct check for:

	if (foo);
		bar();

Could probabally be generalised to look for this kind of error:

	if (foo)
		bar();
		baz();
	one();

-apw
