Return-Path: <linux-kernel-owner+w=401wt.eu-S965507AbXA3QBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965507AbXA3QBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965404AbXA3QBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:01:08 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:34112 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965507AbXA3QBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:01:07 -0500
X-Originating-Ip: 74.109.98.130
Date: Tue, 30 Jan 2007 11:00:07 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <Pine.LNX.4.61.0701301648550.1147@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0701301058300.24690@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0701300938580.24147@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0701301648550.1147@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Jan Engelhardt wrote:

>
> On Jan 30 2007 09:45, Robert P. J. Day wrote:

> >seriously, though, there is the potential of breaking something with
> >this change since you can see how there is some inconsistency in how
> >it's done *now* just for powerpc which, in some places, defines its
> >own versions of this:
> >
> >./arch/ppc/mm/pgtable.c:
> >	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
> >./arch/ppc/syslib/ppc85xx_rio.c:
> >	#define is_power_of_2(x) (((x) & ((x) - 1)) == 0)
> >./arch/powerpc/mm/pgtable_32.c:
> >	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
> >
> >note how the first and third macros *won't* consider zero a power of
> >two, while the second one *will*.  hence the need for a single
> >standard for all of this, just to play it safe.
>
> Hmpf. Perhaps a second macro "is_intdivisible_by_power_of_2" or so could
> catch the "am I zero or 2^n" question.

no.  if that's really what the programmer wants, they can code it that
way explicitly.  let's not make this overly obscure.

rday
