Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZEVSWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZEVSWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZEVSWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:22:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47101 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755732AbZEVSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:22:14 -0400
Date: Fri, 22 May 2009 19:21:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Larry H." <research@subreption.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090522192158.28fe412e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090522180351.GC13971@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<4A15A8C7.2030505@redhat.com>
	<20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
	<20090522143914.2019dd47@lxorguk.ukuu.org.uk>
	<20090522180351.GC13971@oblivion.subreption.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm going to present a very short analysis for different historic leaks
> which had little to do with 'padding bytes in stack', but more like

I wouldn't dispute both classes exist - and a lot of the padding leaks
probably never got a CVE either (eg some of the tty ones just got fixed)

> If the caller provided the page already allocated, the GFP_ZERO
> allocation never happened, and the page was never cleared. Interesting
> issue since my patch basically ensures this doesn't happen. Nevermind.

Which patch are we talking about ? I'm all for a security option which
clears *all* objects on freeing them (actually the poison debug is pretty
close to this). That would fix these examples too.

> At least it's not entirely deceitful. It's definitely dereferencing
> "random memory".

Which could be another task stack you didn't clear - yes ?

> was used to leak kernel memory to userland after a page was allocated at
> NULL by the exploit abusing the issue.

Including task stacks yes ?

And task stacks contain copies of important data yes ?

> My intention here is to make the kernel more secure, not proving you
> wrong or right.

Ditto - which is why I'm coming from the position of an "if we free it
clear it" option. If you need that kind of security the cost should be
more than acceptable - especially with modern processors that can do
cache bypass on the clears.

> You are a smart fellow and I respect your technical and kernel development
> acumen. Smart people don't waste their time on meaningless banter.
> 
> I'll have the modified patches ready in an hour or so, hopefully.

Excellent.

