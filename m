Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYDAMMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYDAMMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYDAMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:12:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34293 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYDAMMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:12:47 -0400
Date: Tue, 1 Apr 2008 14:13:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least
	do it at KERN_CRIT
Message-ID: <20080401121323.GB12129@elf.ucw.cz>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113528.GA8077@elte.hu> <20080328134451.GB4544@ucw.cz> <20080328141348.GE29218@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328141348.GE29218@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-28 15:13:48, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Fri 2008-03-28 12:35:28, Ingo Molnar wrote:
> > > 
> > > * Pavel Machek <pavel@ucw.cz> wrote:
> > > 
> > > > IOMMU off means very bad stuff may happen, like data corruption on 
> > > > your hard drives. At least tells users this is serious...
> > > 
> > > ouch. Please at minimum lets turn this into a panic(), but best would be 
> > > to trim memory in this case, hm?
> > 
> > Andi tells me we already fallback to swiotlb, so messages are not on 
> > wrong loglevel; they contain confusing/obsolete text.
> 
> yes that is the theory - but how did your disk get corrupted in 
> practice? ;-)

Well, if you try suspend/resume, without iommu suspend/resume support
(which is not there in some cases), you get nasty data
corruption. ("PCI DMA will does not work").

Then, I saw [obsolete] printk(KERN_ERR) that told me that PCI DMA will
not work, and happily continued to boot.

I'll fix the messages.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
