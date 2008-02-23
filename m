Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbYBWReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbYBWReq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYBWRee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:34:34 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbYBWRec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:34:32 -0500
Date: Sat, 23 Feb 2008 09:33:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Newall <davidn@davidnewall.com>
cc: Pavel Machek <pavel@ucw.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
       Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
In-Reply-To: <47C013E2.6040201@davidnewall.com>
Message-ID: <alpine.LFD.1.00.0802230913380.21332@woody.linux-foundation.org>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
 <m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org> <m3k5kxq2ih.fsf@maximus.localdomain> <20080222184518.GB6060@ucw.cz> <m3zlts393a.fsf@maximus.localdomain> <20080223094334.GA3081@elf.ucw.cz> <47C013E2.6040201@davidnewall.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, David Newall wrote:
> 
> Do you actually get 80 columns wide on it?

Do people really care that deeply?

I still sometimes use small terminal windows - for a while I had my 
default terminal come up as 100x40, but I'm back to the standard 80x24, 
and while I often resize them, I certainly don't always.

And do I find lines longer than 80 charactes unreadable? Hell no.

Quite frankly, on a 80x24 display, I'll take long lines over split-up ones 
*any* day. For things like doing "git grep xyzzy", I'd *much* rather get 
the occasional long line that wraps (or, if I'm in "less -S", that I have 
to press right-arrow to see), than see just a meaningless fragment because 
somebody decided that they should always fit in 80 characters.

So *consistently* long lines are the problem, not the occasional one. The 
occasional one is likely more readable as it is, than split up.

Here's an example from code that actually looks pretty good in general:

	static unsigned long
	calc_delta_mine(unsigned long delta_exec, unsigned long weight,
	                struct load_weight *lw)

and look around that function in general: it's doesn't match the coding 
standard, but also compare the output of

	git grep calc_delta_mine

with the output of something like

	git grep update_load_sub

which actually shows you what the calling convention is.

So putting that long function definition on one line would make it a
108-character line or somethign like that, but it would have advantages
too.  It would have advantages for anything that is line-based (I use
grep for *everything*, but maybe I'm just odd), but it would also
actually be more readable for the people who have bigger windows.

But my point is, some of those advantages remain even with small
terminals, and quite often the downsides aren't even all that huge. 
Most editors wrap or chop the line according to your preferences (mine
are personally to chop), and if it's a fairly uncommon thing, those
downsides shrink further. 

Is 108 characters perhaps *too* long? In the above case it probably is,
since the downside of splitting the patch is pretty small (it's a static
function, only used in that file, the "grep" argument is weak, yadda
yadda).  But I'm just saying that it's not 100% obvious *even*if* you're
on a 80x24 terminal, and in some other cases the downside of splitting
the line can be much bigger (strings or more spread-out function calls
and declarations etc). 

The line length problem would probably be better attacked as something
more akin to the rule

 - do a rolling window of <n> last non-empty lines (n ~ 15 or so)

 - if more than <m> of those lines were longer than 72 charactes,
   somethign is wrong (m ~ 5 or so). 

which talks more about what matters - too deep indentation. And also 
attacks the problem that is really relevant: it's that kind of code that 
ends up being unreadable because so *much* of it is cut off or wrapped.

			Linus

