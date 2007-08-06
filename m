Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbXHFKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbXHFKU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762414AbXHFKUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:20:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:42886 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762047AbXHFKUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ELVZNCYkn+DNEXzQhKZ0KQOHZ54fuuZznMRiCJZqK1gaWiWt/NbDue5ZFKSeBXDcHtVQ8E9OqAL5ESz8PPY0qGeby26ZJVtFm14NgAArSw0475iz9cz5830A7IX5Dqm7dSU90qnrs4wZbG8OY6qgR/uf1yILuwE1a6v1rceX9I4=
Message-ID: <1a297b360708060320m2e9aa419n1f043fb18d987850@mail.gmail.com>
Date: Mon, 6 Aug 2007 14:20:10 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH] msleep() with hrtimers
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, akpm@linux-foundation.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708061159370.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032152060.1817@scrub.home>
	 <1186185229.3153.11.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708040345530.1817@scrub.home>
	 <1186255149.2777.3.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
	 <1186360983.2697.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060257010.1817@scrub.home>
	 <1186378798.2697.10.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708061159370.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Sun, 5 Aug 2007, Arjan van de Ven wrote:
>
> > > There's no problem to provide a high resolution sleep, but there is also
> > > no reason to mess with msleep, don't fix what ain't broken...
> >
> > John Corbet provided the patch because he had a problem with the current
> > msleep... in that it didn't provide as good a common case as he
> > wanted... so I think your statement is wrong ;)
>
> Only under the assumptation, that msleep _must_ be "fixed" for all other
> current users too.
> Give users a choice to use msleep or nanosleep, how do you know what's
> "best" for them?
>

You mean to say, the granularity of msleep is in mS with a tolerance
of +/- "n" mS whereas nanosleep would have the tolerance in nS ?
(ignoring all the discussions about hrtimers and their internal
design)

I guess many people are/were confused on the aspect that, a msleep(1)
meant sleep for a 1mS and nothing more. Well, this would explain, some
of my hair raising incidents, if i understood you correctly.

Since it is such a confusion, maybe it needs to be documented some
place, that people don't fall into the same trap.

Manu
