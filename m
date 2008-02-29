Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbYB2RTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbYB2RTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbYB2RS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:18:59 -0500
Received: from panic.printk.net ([217.147.83.20]:34422 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760744AbYB2RS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:18:58 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: Jon Masters <jonathan@jonmasters.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Roskin <proski@gnu.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1204304352.6767.21.camel@localhost>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 29 Feb 2008 12:18:12 -0500
Message-Id: <1204305492.3501.83.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 09:59 -0700, Zan Lynx wrote:
> On Fri, 2008-02-29 at 08:08 -0800, Linus Torvalds wrote:
> [cut]
> > It loads non-GPL code, it is non-GPL.
> [cut]
> > Exactly. And ndiswrapper loads proprietary modules.
> 
> The Linux kernel itself will load proprietary modules.  It does not as a
> general rule, but it will.

And when that happens, the same taint flag will be set. Your argument is
a non-argument :)

But anyway...

FWIW, I wasn't actually trying to start this debate with the patch I
sent before - I was simply correcting what seemed to be "obviously"
broken logic in module.c for handling ndiswrapper[0]. I was auditing the
taint flags for a backport to another kernel, and noticed this. Having
said that, there would seem to be two directions this can now go in:

*). Back out this patch, go back to previous situation. But then there's
still special case logic for ndiswrapper, and it's not really doing what
people would likely consider the "right" thing with its tainting then. I
again suggest that ndiswrapper would need to be sure to set the taint
flags itself, which would be an alternative to "policing" it.

*). Keep this patch. And potentially add some more for other similar
shim layers - I can think of a certain graphics driver that might
qualify for similar treatment, if one wants to go there. But I might
need to find a tailor specializing in *really* fire retardant pants
before I think of being the one who submits that patch.

I've no idea what "the right thing" is here, but many seem to think it
involves backing out this patch (the most compelling argument given so
far is that it might force ndiswrapper simply to change its name, and
that there's no clear idea if the kernel should be enforcing ideology).
Since we've brought it up, one good thing I would like to see come of
this perhaps is a clearer understanding of what the kernel should and
should not be doing in terms of "license compliance enforcement". We
have had lots of talk, but perhaps a "policy" document is worthwhile.

Jon.

[0] If this is reverted, please do stick in a reference to:
http://lwn.net/Articles/205644/ to avoid repeats.


