Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZIHORY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZIHORY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZIHORX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:17:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:57921 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZIHORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:17:23 -0400
Date: Tue, 8 Sep 2009 07:20:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908072046.3932fd50@infradead.org>
In-Reply-To: <4AA62E4E.4040700@arcor.de>
References: <20090906205952.GA6516@elte.hu>
	<h81v7t$p6e$1@ger.gmane.org>
	<20090907074039.1b6bc1ac@infradead.org>
	<4AA6056A.4020106@arcor.de>
	<20090908013800.296a5fb5@infradead.org>
	<4AA62E4E.4040700@arcor.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Sep 2009 13:13:34 +0300
Nikos Chantziaras <realnc@arcor.de> wrote:

> On 09/08/2009 11:38 AM, Arjan van de Ven wrote:
> > On Tue, 08 Sep 2009 10:19:06 +0300
> > Nikos Chantziaras<realnc@arcor.de>  wrote:
> >
> >> latencytop has this to say:
> >>
> >>     http://foss.math.aegean.gr/~realnc/pics/latop1.png
> >>
> >> Though I don't really understand what this tool is trying to tell
> >> me, I hope someone does.
> >
> > despite the untranslated content, it is clear that you have
> > scheduler delays (either due to scheduler bugs or cpu contention)
> > of upto 68 msecs... Second in line is your binary AMD graphics
> > driver that is chewing up 14% of your total latency...
> 
> I've now used a correctly installed and up-to-date version of
> latencytop and repeated the test.  Also, I got rid of AMD's binary
> blob and used kernel DRM drivers for my graphics card to throw fglrx
> out of the equation (which btw didn't help; the exact same problems
> occur).
> 
> Here the result:
> 
>      http://foss.math.aegean.gr/~realnc/pics/latop2.png
> 
> Again: this is on an Intel Core 2 Duo CPU.


so we finally have objective numbers!

now the interesting part is also WHERE the latency hits. Because
fundamentally, if you oversubscribe the CPU, you WILL get scheduling
latency.. simply you have more to run than there is CPU.

Now the scheduler impacts this latency in two ways
* Deciding how long apps run before someone else gets to take over
  ("time slicing")
* Deciding who gets to run first/more; eg priority between apps

the first one more or less controls the maximum, while the second one
controls which apps get to enjoy this maximum.

latencytop shows you both, but it is interesting to see how much the
apps get that you care about latency for....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
