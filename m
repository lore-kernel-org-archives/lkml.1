Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYBRQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYBRQv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYBRQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:51:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYBRQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:51:17 -0500
Date: Mon, 18 Feb 2008 08:50:18 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080218085018.05f3190a@laptopd505.fenrus.org>
In-Reply-To: <p73mypyxx6z.fsf@bingen.suse.de>
References: <200802171025.30590.elendil@planet.nl>
	<20080217124650.576990ce@laptopd505.fenrus.org>
	<p73mypyxx6z.fsf@bingen.suse.de>
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

On Mon, 18 Feb 2008 13:31:48 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> >
> > the initial plan was for a depreciation period. Sadly it was
> > untenable since the API was changing entirely to fix bugs and add a
> > really important feature (the ability to clflush the exact range
> > rather than wbinvd'ing the caches of all cpus in the system), 
> 
> Just for the record: I posted full patches to implement clflush
> support some time ago without changing any exported API. So your
> claims that changing the API was needed to implement CLFLUSH are not
> correct.

yeah of course it is possible to make things "smart" by having hidden state.
doesn't make it right.

> 
> Also I believe some assumptions behind the new API are faulty (in
> particular that the caller doesn't fully own the to be changed pages)
> and make it actually impossible to implement the cache attribute PTE
> changing operation fully correct according to the Intel x86 manual
> (which requires temporary unmap)

the Intel x86 manual explicitly only has a temporary unmap when going from a 
cached state to a write-combining state. Any other transition does not require
an unmap. Which makes this not impossible, all a cached->WC transition needs
to do is go via an intermediate UC state and the really expensive process from
the manual is not needed.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
