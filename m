Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXBSMP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXBSMP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932193AbXBSMP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:15:27 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31656 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192AbXBSMP0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:15:26 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <45D994FB.2080606@amd.com>
Date: Mon, 19 Feb 2007 13:15:55 +0100
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070206)
MIME-Version: 1.0
To: "=?ISO-8859-1?Q?=C9ric_Piel?=" <Eric.Piel@tremplin-utc.net>,
       "Oliver Neukum" <oliver@neukum.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: O2micro smartcard reader driver.
X-OriginalArrivalTime: 19 Feb 2007 12:15:08.0995 (UTC)
 FILETIME=[98F04130:01C7541F]
X-WSS-ID: 69C74B5A2MC8591055-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/19/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> 02/17/2007 04:55 AM, Markus Rechberger wrote/a écrit:
> > Hi Eric,
> >
> > I committed your code to linuxtv.org to review and modify it there.
> > http://linuxtv.org/hg/~mrechberger/chipcardreader
> >
> > one thing I noticed is the error handling in ozscr_probe.
> >
> > I'll continue the rest during the next few days, I'd like to see it as
> > soon as possible in the upstream kernel before some kernel api changes
> > again which affects your current driver.
>
> Hi Markus,
>
> Thank you very much for finding new bugs ;-) Actually, right now I've
> just moved and don't have internet at home which is kind of slowing down
> development... Anyway, I'll check if I have some more fixes on my
> computer than on my website. Also, it would be good to double check some
> lines which I've commented XXX. In particular, IIRC there were some
> suspicious sleep saying it was sleeping a microsecond and sleeping one
> millisecond!

as user noone cares if it's 1 ns or 1 ms, since that part seems to work
as it is just leave it.

>
> I'm also a bit concerned about the userspace "driver" for pscd which
> comes with the original driver once the patch will be part of the
> default kernel. Maybe this userspace part could become part of the
> pscdlite distribution.
>

I couldn't find the sources of the userspace library, the link on
musclecard.com is dead (and there's no backup on archive.org)

> Wrt the module having always a usecount value of 1, it was worrying me
> too at the begining until I noticed it decreased back to 0 once the card
> is "ejected" (pccardctl eject 1). Although a bit surprising, I don't
> think it's a bug, is it?

this is where the pcmcia/pccard framework bug becomes relevant. The
usecount is no bug, but the lockup (which got explained in the other
mail) is one
>
> See you,
> Eric
>
>


-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG



