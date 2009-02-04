Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZBEPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZBEPOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBEPOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:14:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53628 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZBEPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:14:10 -0500
Date: Wed, 4 Feb 2009 17:17:52 +0100
From: Pavel Machek <pavel@suse.cz>
To: Roger Larsson <roger.larsson@e-gatan.se>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Robert Love <rml@tech9.net>
Subject: Re: PROBLEM: in_atomic() misuse all over the place
Message-ID: <20090204161751.GC1218@ucw.cz>
References: <200901280010.37633.roger.larsson@e-gatan.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901280010.37633.roger.larsson@e-gatan.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-01-28 00:10:37, Roger Larsson wrote:
> (resent, non html)
> 
> [1.] One line summary of the problem:    
> in_atomic() is used to select path of execution, most likely to suppress 
> warning logs when running a preemptive kernel.
> 
> [2.] Full description of the problem/report:
> 
> The problem is that in_atomic() only works on preemptive kernels...
> 
> Result: preemptive kernel warns about a potential deadlock in all kernels,
> developer silence with the help of in_atomic()
> bug remains in SMP/UP kernels...

I guess in_atomic() should be renamed to
unreliable_in_atomic... because it does not really reliably tell you
if you are in atomic section or not.

Or we could negate the logic and call it maybe_kernel_context()?

gfp_any() also needs a better
name. pick_right_gfp_if_you_are_in_kernel_or_softirq_context() sounds
suitable :-).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
