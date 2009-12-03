Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZLCJMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZLCJMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZLCJMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:12:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48667 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZLCJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:12:37 -0500
Date: Thu, 3 Dec 2009 10:12:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
	add/remove
Message-ID: <20091203091206.GA1478@ucw.cz>
References: <4B0EA88E.3030205@linux.vnet.ibm.com> <1259252382.31676.207.camel@laptop> <4B0EAC06.3010407@linux.vnet.ibm.com> <1259252892.31676.220.camel@laptop> <4B0EAD7B.90601@linux.vnet.ibm.com> <1259253950.31676.249.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259253950.31676.249.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >>> Aside from that, we probably should put an upper limit in place, as I
> > >>> guess large cpu count machines get silly large values
> > >>>       
> > >> I agree to that, but in the code is already an upper limit of 
> > >> 200.000.000 - well we might discuss if that is too low/high.
> > >>     
> > >
> > > Yeah, I think we should cap it around the 8-16 CPUs.
> > >
> > >   
> > ok for me, driven by that finding I think I have to measure different 
> > kind of scalings anyway, but as usually that takes some time :-/
> > At least too time much for the discussion & solution of that bug I guess.
> > 
> > The question for now is what we do on cpu hot add/remove?
> > Would hooking somewhere in kernel/cpu.c be the right approach - I'm not 
> > quite sure about my own suggestion yet :-).
> 
> Something like the below might work I suppose, just needs a cleanup and
> such.

I see a rather fundamental problem: what if user wants to override
those values, and wants them stay that way?

If you do this, suspend/resume will put the old values back AFAICT.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
