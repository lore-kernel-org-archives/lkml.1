Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZCYRCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZCYRCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZCYRC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:02:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746AbZCYRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:02:25 -0400
Date: Wed, 25 Mar 2009 09:59:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Credit for vsprintk work
In-Reply-To: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0903250944360.3032@localhost.localdomain>
References: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Steven Rostedt wrote:
> 
>  $ git blame lib/vsprintf.c |grep 'Frederic Weisbecker' | wc -l
> 542
> 
> You did a hell of a lot of work on vsprintf.c, and you are still too 
> modest to put in a copyright at the top.

I don't disagree, but "git blame" is _not_ a good way to do this.

At a minimum, use "git blame -w -M" to ignore stuff that was just moved 
and re-indented. but even then, quite frankly, "git blame" doesn't really 
make much sense. If you have

	if (!(flags & LEFT)) {
		while (len < field_width--) {

that turns into

	if (!(spec.flags & LEFT)) {
		while (len < spec.field_width--) {

then blame will count the new lines to the person who did the change, but 
was that really a code change? It was a small re-org.

I picked that example because those particular lines actually go back to 
before even the bitkeeper days - their original author is lost in history. 
It used to look different (field_width was called 'size' back in the 
days), but the logic of the code may well go back to the original code by 
Lasu in 1991.

The only point here? Don't use "git blame" as a copyright assigner.

			Linus
