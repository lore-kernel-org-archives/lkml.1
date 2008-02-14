Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbYBNWJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbYBNWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYBNWJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:09:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41053 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYBNWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:09:18 -0500
Date: Thu, 14 Feb 2008 14:08:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214140816.68b47407@laptopd505.fenrus.org>
In-Reply-To: <20080214214241.GB19473@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org>
	<20080214161218.GA28152@elte.hu>
	<20080214171603.GC16255@one.firstfloor.org>
	<20080214183819.GA19846@elte.hu>
	<20080214214241.GB19473@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 22:42:41 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Feb 14, 2008 at 07:38:19PM +0100, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > this is indeed a bug (we change the attributes for a larger
> > > > area than needed), but your fix is unclean. Find below a
> > > > cleaner solution.
> > > 
> > > You're still ignoring the other problem of set_memory_uc() not 
> > > handling fixmap and ioremap correctly. [...]
> > 
> > No, we did not ignore it, and yes, you are wrong.
> > 
> > One thing that you miss is that the 64-bit EFI runtime has to be
> > marked uncacheable only if it the EFI image attribute signals an
> > uncacheable area:
> > 
> >                 if (!(md->attribute & EFI_MEMORY_WB))
> >                         set_memory_uc(md->virt_addr, md->num_pages);
> > 
> > and Linux EFI does not support device EFI runtimes. So your
> > observation, 
> 
> Sorry I didn't get that (you were a bit terse). 
> 
> You're saying the EFI BIOSes will never set that flag ?
> 
> I'm reading page 123+ of UEFI 2.1 which describes GetMemoryMap() 
> and these flags and I see nothing to that effect. I admit I didn't
> read the full EFI bible so far so there are certainly EFI
> aspects I don't understand.
> 
> Can you please clarify why EFI would not set that flag on Linux?

because it will only normally get set on EFI code that lives in device memory.
There's no reason to ever use non-cache for ram this way. Ever. Non-cached execution
is a TOTAL pain for anything, and will be avoided if at all possible.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
