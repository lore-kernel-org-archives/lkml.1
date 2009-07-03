Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZGCQY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZGCQY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZGCQYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:24:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44178 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbZGCQYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:24:50 -0400
Date: Fri, 3 Jul 2009 18:24:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703162443.GB21399@elte.hu>
References: <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk> <20090703144754.GA13246@elte.hu> <20090703160230.093e422c@lxorguk.ukuu.org.uk> <20090703154845.GB13580@elte.hu> <20090703171117.574677de@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703171117.574677de@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > So did i get you right that in your opinion sending and writing 
> > clean code is a 'bogus standard'? Sorry about trying to 
> > interpret you here, i have no choice because you did not reply 
> > to my question.
> 
> Your definition of "clean code" being ?

Clean code is one that is not unclean. Unclean code is for example 
one that does:

+       if( tty->count == 1 && port->count != 1) {

and you pushed that piece of code upstream, and you called 
checkpatch a religion - so apparently you were not using that tool 
and apparently you think it's fine to push such changes upstream.

I.e. your action proves that you are willing to push unclean code, 
and you gave various explanations about why you are not using tools 
that can catch such mistake . Am i allowed to express my 
disagreement with that notion?

> > I thought the obvious portions of Documentation/CodingStyle 
> > applied to everyone - so it applies to you only if you like it?
> 
> CodingStyle is a guide - it applies as a guide to people. It's 
> also lower priority than working code. Which is why for example we 
> have staging. Linus pretty clearly ruled where the priorities were 
> I think in accepting staging. [...]

But drivers/char/ is not in drivers/staging/, is it?

If you cite drivers/staging/ an argument to introduce unclean code 
into core pieces of Linux then i think you are dead wrong ...

Yes, any textual guide about code is pretty much by definition just 
a guide - to be overruled by common sense as usual.

And i dont think there exists a valid interpretation that says that 
this introduction of unclean code:

$ git log -p -1 a6614999e800cf3a134ce93ea46ef837e3c0e76e | grep -iE 'if.*tty->count'
-       if (tty->count == 1 && port->port.count != 1) {
-       if (tty->count == 1 && port->count != 1)
-	if ((tty->count == 1) && (info->port.count != 1)) {
-       if ((tty->count == 1) && (port->port.count != 1))  {
-       if (tty->count == 1 && port->count != 1)
-       if ((tty->count == 1) && (info->port.count != 1)) {
-       if ((tty->count == 1) && (info->port.count != 1)) {
-	if ((tty->count == 1) && (info->port.count != 1)) {
+       if( tty->count == 1 && port->count != 1) {

was warranted by any common-sense argument. You changed well-working 
code into something different (and unclean) and you - as you have 
repeatedly pointed it out in this thread - disagree with using 
checkpatch - why? It makes no technical sense.

Yes, it's all a minor issue in the end - but you chose to argue 
about the technical review feedback (which i still consider 
correct), not me.

	Ingo
