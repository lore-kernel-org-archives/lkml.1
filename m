Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892Ab0A2W1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0A2W1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797Ab0A2W1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:27:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:10932 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0A2W1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Q71XQ/RBuTYsVeNdOoEU5DbN9rxHfhBPI+ZIC+FYzE+xsXXKIiuGKY7tUtzso0YRA5
         dIRcb0G7JZrnmQGhsLIoE9dNyvRRbtNcAEAaNJmHZ91qOGB67o2upCjooOMOVpgC3h02
         vcDNSL8y1u2YLLplDogcHOzRphVdYfH2iXP40=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/68] ide2libata
Date: Fri, 29 Jan 2010 23:24:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100129160308.21495.14120.sendpatchset@localhost> <4B6355DF.9050001@garzik.org>
In-Reply-To: <4B6355DF.9050001@garzik.org>
MIME-Version: 1.0
Message-Id: <201001292324.55222.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 January 2010 10:40:47 pm Jeff Garzik wrote:
> On 01/29/2010 11:03 AM, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > Here is a patchset (on top of atang-v3.1 tree) applying "out-of-the-box"
> > thinking to duplicated libata PATA and IDE subsystem host driver sets.
> > Namely, it modifies IDE API slightly to match libata's one more, adds
> > a tiny source-code level translation layer (ide2libata.h header file
> > which consists of only 17 lines of code) and then converts host drivers
> > to use shared source code for low-level operations (all drivers have
> > been carefully audited during porting to minimize the probability of
> > adding regressions accidentally).  As an end result it is much easier
> > to maintain both driver sets (differences between 'new'/'old' drivers
> > are now apparent and there is no longer a need to manually back-port
> > many classes of bugfixes) and over 2500 LOC are gone.
> 
> Interesting.
> 
> I'm fine with applying patches 2-5, but I am definitely interested to 
> hear what others think about this.  Clearly, LOC is reduced, but that's 
> not the only factor in code maintenance.
> 
> With regards to libata and old-IDE, I have always thought the ideal 
> scenario was to leave old-IDE in bugfix-only mode, with next-to-no API 
> or driver churn besides that which is absolutely required for the fix.
> 
> En masse backporting bug fixes is what's known as a one-time cost.  Once 
> the majority of libata PATA drivers reach bugfix and feature parity, the 
> need for code sharing is reduced greatly.
> 
> The ide2libata proposal creates on-going costs, not just a one-time 
> cost, because the old-IDE drivers will have -increased- potential for 
> problems when a libata PATA driver is modified.  Such is the -cost- of 
> heavily intertwined code sharing.  A single header change implies that 
> two, not one, drivers might break.  That weakens the "leave it alone" 
> stability promise of old-IDE.

I understand your concerns (especially given that libata PATA drivers
are unmaintained) but this patchset is for atang tree which is what I use
personally and I have no problem with maintaining it as long as I find it
useful (porting few hundreds patches once in few months against upstream
is much cheaper in terms of time/sanity than obligatory discussions on
whether to document known end-user visible limitations in driver's Kconfig
help text or in driver's source code how etc.).

Starting with 2.6.33 kernel.org users will be covered with a dedicated
patch and if distribution users want some changes that are in atang they
should ping their distribution about it, not me (if some distribution
would like to pay for the work on integrating some changes and/or getting
other ATA changes integrated please contact me in private).

IOW I'm just doing what I find useful/interesting for me and I don't care
much personally if it ever reaches upstream.  I post patches mainly for
an extra review and to prevent duplication of efforts.  If people find them
useful, great.  If not, well, not a big deal (having 2000 commits upstream
changes a perspective a bit)..

> Waiting for other comments...  this patchset is not an onerous burden to 
> libata, but I think it creates nasty cross-tree issues, potentially 
> perturbing old-IDE.

I'm rather time constrained these days so I think that I'll skip such type
of discussion entirely (though technical comments like bugs in patches etc.
are warmly welcomed and appreciated)..

--
Bartlomiej Zolnierkiewicz
