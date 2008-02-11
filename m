Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYBKPWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYBKPWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYBKPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:21:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56228 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYBKPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:21:58 -0500
Date: Mon, 11 Feb 2008 07:21:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support
 self-snoop
Message-ID: <20080211072109.029bb6c5@laptopd505.fenrus.org>
In-Reply-To: <200802111612.56662.ak@suse.de>
References: <200802111050.372086035@suse.de>
	<20080211095022.7B8C31B41CE@basil.firstfloor.org>
	<20080211070430.099fbded@laptopd505.fenrus.org>
	<200802111612.56662.ak@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 16:12:56 +0100
Andi Kleen <ak@suse.de> wrote:

> On Monday 11 February 2008 16:04:30 Arjan van de Ven wrote:
> > On Mon, 11 Feb 2008 10:50:22 +0100 (CET)
> > Andi Kleen <ak@suse.de> wrote:
> > 
> > > 
> > > [2.6.25 candidate I believe]
> > > 
> > > The specification of SS in the public manuals is a little unclear,
> > > but I got confirmation from Intel that SS implies that there is no
> > > cache flush needed on caching attribute changes.
> > 
> > I'm hearing slightly different information, but am still chasing
> > this one.
> 
> 10.12.8 in the ia32 manual volume 3a says:
> 
> "
> When remapping a page that was previously mapped as a cacheable
> memory type to a WC page, an operating system can avoid this type of
> aliasing by doing the following:
> ...
> 
> 3. Create a new mapping to the same physical address with a new
> memory type, for instance, WC.
> 4. Flush the caches on all processors that may have used the mapping
> previously. Note on processors that support self-snooping, CPUID
> feature flag bit 27, this
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> step is unnecessary. ^^^^^^^^^^^^^^^^^^^^
> "
> 
> That is exactly the situation in pageattr.c. You're saying the manual
> is wrong here?

I'm saying that we are not following step 2 (marking the pages not present) so 3 and 4
aren't all too relevant. As I said before I've asked internally about this and got
mixed answers so I'm still chasing it down.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
