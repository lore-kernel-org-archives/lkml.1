Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYKKMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYKKMuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbYKKMuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:50:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56602 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbYKKMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:50:31 -0500
Date: Tue, 11 Nov 2008 11:45:51 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081111104551.GE5464@elf.ucw.cz>
References: <20081109140726.GB1786@ucw.cz> <20081110080436.GF2093@elte.hu> <87hc6fpwof.fsf@basil.nowhere.org> <200811101928.04565.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811101928.04565.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-10 19:28:03, Rafael J. Wysocki wrote:
> On Monday, 10 of November 2008, Andi Kleen wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > >
> > > No good ideas - the bug description gives me the impression of memory 
> > > maps save/restore hickup in the hibernation code - and memory maps are 
> > > pretty much the only thing that are significantly different on NUMA. 
> > 
> > I assume the problem happened on a single node system.
> > On single node the memory map should be actually quite similar
> > to the UMA case.
> 
> It is.  However, the problem is 100% reproducible on any 32-bit single-node
> system with CONFIG_NUMA set, from what I can tell.
> 
> It doesn't happen if the kernel is booted with highmem=0, so it looks like
> the code that saves highmem causes the problem to happen.  However, this
> same code works well for all of the !CONFIG_NUMA cases and practically only
> the only non-open-coded it uses is kmap_atomic().
> 
> > One possibility would be to bisect if it ever worked?
> 
> Not sure it did, probably not. :-(

Well, interesting point would be just before this commit:


commit 8357376d3df21b7d6f857931a57ac50da9c66e26 
tree daf2c369e9b79d24c1666323b3ae75189e482a4a 
parent bf73bae6ba0dc4bd4f1e570feb34a06b72725af6 
author Rafael J. Wysocki <rjw@sisk.pl> Wed, 06 Dec 2006 20:34:18 -0800 
committer Linus Torvalds <torvalds@woody.osdl.org> Thu, 07 Dec 2006
08:39:27 -0800 

    [PATCH] swsusp: Improve handling of highmem
    
    Currently swsusp saves the contents of highmem pages by copying
them to the
    normal zone which is quite inefficient (eg.  it requires two
normal pages
    to be used for saving one highmem page).  This may be improved by
using
    highmem for saving the contents of saveable highmem pages.

...highmem handling was way simpler in those good old days ;-)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
