Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXDTT6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXDTT6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXDTT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:58:00 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:58630 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbXDTT57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KoO9l28eb6MF8g5cu5O/tpMUJywf/+OXcoOXsQAW92yihKPPCmrbJvQPtAKTytr4ZzU3juvkoLs7G6zZeYto02q4+SgsJtWlWryAKy3196sY17vzmG142o6ie634QVotng8tic8Ei7x+B0+O+0mxDuR/3XPCnu0L14Wc4UQXpuw=
Message-ID: <b637ec0b0704201257l24d9e9c8ha31221c9c9d8da3e@mail.gmail.com>
Date: Fri, 20 Apr 2007 21:57:56 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: Stephen.Clark@seclark.us, "Mark Lord" <liml@rtr.ca>,
       "Tejun Heo" <htejun@gmail.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       7eggert@gmx.de, emisca <emisca.ml@gmail.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       "Adrian Bunk" <bunk@stusta.de>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <4627ABE9.8090906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <88SeR-5Sf-15@gated-at.bofh.it>
	 <20070418140346.636879a1@the-village.bc.nu> <46262C0E.9000103@rtr.ca>
	 <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca>
	 <46263859.2060309@gmail.com> <46265089.4000409@rtr.ca>
	 <46265307.7060405@rtr.ca> <4626596E.4040304@seclark.us>
	 <4627ABE9.8090906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bingo!
I switched from ata_piix.c to piix_ide.c and the "pop" disappeared.

I must say that the "pop" also disappeared after suspending to disk
using suspend2 (obviously without executing halt -n -h -p) . In both
cases it was present with the previous setup.

This is with a pure PATA setup with no SATA ports and the disk is:

hda: TOSHIBA MK8025GAS, ATA DISK drive

Many thanks!
regards,
Fabio




On 4/19/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Stephen Clark wrote:
> > Mark Lord wrote:
> >
> >> Mark Lord wrote:
> >>
> >>
> >>> With the patch applied, I don't see *any* new activity in those
> >>> S.M.A.R.T.
> >>> attributes over multiple hibernates (Linux "suspend-to-disk").
> >>>
> >>
> >> Scratch that -- operator failure.  ;)
> >> The patch makes no difference over hibernates in the SMART logs.
> >>
> >> It's still logging extra Power-Off_Retract_Count pegs,
> >> which it DID NOT USED TO DO not so long ago.
> >>
> >> Now I'll poke at the shutdown again.
> >>
> >> Meanwhile, Stephen:  Could you try without this line in the patched file:
> >>
> >>        case ATA_16:
> >> +               dev->needs_sync_cache = 1;
> >>
> >> Ie. comment out that last "dev->needs_sync_cache" line.
> >>
> >>
> > No joy - even with that line commented out I get a click and my
> > Power-Off_Retract_Count has incremented.
> >
>
> I found a solution of sorts on Fedora 6:
>
>
> Edit /etc/rc0.d/S01halt, changing the third-from-last line so it reads:
>
> HALTARGS="-d -h -n"
>
> Then use the halt(8) command to shut down and turn off the power manually.
> No click and the "retract" counter does not increment. (Even this procedure
> incremented the counter until I changed the script.)
>
> Seems safe, using the IDE drivers, since they sync the cache anyway.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
