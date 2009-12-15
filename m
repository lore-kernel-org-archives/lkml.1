Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZLNX7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZLNX7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZLNX7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:59:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:39880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866AbZLNX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:59:34 -0500
Date: Mon, 14 Dec 2009 16:01:53 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Emese Revfy <re.emese@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
 2.6.32-git-053fe57ac v2
Message-ID: <20091214160153.2edfd026@infradead.org>
In-Reply-To: <4B26BA4A.7080602@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
	<20091214003836.GD7812@parisc-linux.org>
	<4B2595E7.701@gmail.com>
	<20091214021916.GB12196@linux-sh.org>
	<4B25E47C.1010803@gmail.com>
	<20091214123636.GA7417@linux-sh.org>
	<4B26BA4A.7080602@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 23:20:58 +0100
Emese Revfy <re.emese@gmail.com> wrote:

> Paul Mundt wrote:
> > I don't see anything relating to sparse in that mail. You've
> > effectively lumped sparse and constification together in the same
> > camp, but it's unclear why this makes constification a better
> > option other than that it's simply the option you opted for. All of
> > your arguments "against" sparse in that context are equally
> > applicable to constification, so I'll reiterate that you haven't
> > sufficiently addressed the sparse angle.
> > 
> > At present you seem to be the only one convinced that
> > constification is the way to go, despite it being highly intrusive
> > and ignoring the potential for more favourable and less intrusive
> > options. You've also failed to adequately address the issues and
> > suggestsions pointed out by others, and until this happens there is
> > little point in posting any follow-up patches.
> > 
> >>> Until such a consensus is reached one way or the other, please
> >>> refrain from sending hundreds of patches -- one or two are
> >>> sufficient for showing what you want to do until folks are on
> >>> board with it, as is the typical nature of mechanical changes.
> >> I think there is consensus to constify ops variables as much as
> >> possible (e.g., Alexey's similar patches).
> >>
> >> The discussions in these threads were about constifying the ops
> >> structure fields themselves and I already explained why they are
> >> useful, see the above link and this one:
> >> http://lkml.org/lkml/2009/12/8/492
> > 
> > And in here as well in the reply to that mail the same criticism
> > exists as does the suggestion to look at doing it cleanly in
> > sparse, which brings us back to what was already mentioned earlier.
> 
> Let me summarise the discussion so far:
> 
> As per Al Viro, Arjan and other developers the goal is to force
> static allocations and prevent runtime modification of ops structures
> (where it is possible, there are always exceptions like
> ata_port_operations).
> 
> The current strategy of constifying variables achieves the second
> goal only, it still requires human review to catch violations of the
> first goal.

this is not correct.

When the ops variable is const... the compiler will also warn if you
change it. Make some core APIs use const in their parameter that gets
a pointer to the ops structure, so that the compiler can optimize.
That is all goodness.

But if someone somewhere makes one that is not const.. that's what
checkpatch.pl is for .. make it warn!
But don't crap all over structures... I agree with Pavel/Al/etc.. 
that's bad code without gains.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
