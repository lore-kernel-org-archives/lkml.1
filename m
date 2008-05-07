Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbYEGVzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbYEGVzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYEGVzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:55:41 -0400
Received: from www.tglx.de ([62.245.132.106]:54444 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbYEGVzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:55:39 -0400
Date: Wed, 7 May 2008 23:54:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <20080507212343.GB14951@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
 <20080507212343.GB14951@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Adrian Bunk wrote:
> On Wed, May 07, 2008 at 10:52:36PM +0200, Thomas Gleixner wrote:
> > We have a well identified set of CPUs which can handle PAT and we dont
> > want to open up a can of worms by unconditionally enabling it on any
> > piece of silicon which claims to support PAT. This was made clear from
> > the first submission of PAT.
> 
> But the commit description is empty.

Care to read, what I wrote futher down ?

"Yes, that's a valid complaint. The changelog is pretty useless."
 
> > Also there is no downside on these older systems. They are fine with
> > MTRRs and have been for years. We can revisit that once PAT support
> > has stabilized.
> 
> My comment was about:
> "please try attach patch to see if duron support PAT."

I know.
 
> That information is for sure available.

So you know where it is and you can confirm that it works fine ?

Pointers please. 

> > This feature and detection code is hard to clean up and definitely out
> > of the scope of this patch.
> 
> Did you even look at the commit we are discussing?
> 
> It ***adds*** exactly the same code at three different places.

Yes, I did. And it adds it for a fscking good reason. 

1) two times in common.c due to the existing detection logic mess
2) once in the 64 bit version

Again, this code is inherited and fragile mess, which can not be
changed at will.

> >...
> > > And this patch (by the author of the code himself) is the first time 
> > > where it breaks.
> > 
> > Very interesting analysis. What broke ? This CPU was never in the set
> > of supported ones at all.
> 
> The patch in the email I answered to was broken since the author did 

"the author" has a name.

> fall into his own trap by patching only one copy of his duplicated code.

That's not a real good reason to yell at him.

Yinghai  wanted to help out and check with the reporter whether this CPU
works with PAT or not.

Yinghai made a mistake.

You come along and ride a crusade against him for that. Very helpful.

Thanks,

	tglx
