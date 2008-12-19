Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYLSVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYLSVTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYLSVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:19:46 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:62201 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYLSVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:19:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=oxsRsMq3onTMfYIrwKyaKstd34ViN1jnSXsmoiUmtMhov1gitlaCcSfY+iJUj1H10A
         I3m63DP2f6LQqluzo0D2Pr4PGob/dLw3iKPbn6CD+46TJbpf8uL73Z3HqWEYJLQ/52Hp
         fr4fBIeh4/QOOnFYMRQl1/7r8JnbMzzptjmoQ=
Date: Fri, 19 Dec 2008 22:19:45 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/8] ide-cd: first conversion batch
Message-ID: <20081219211945.GA8451@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com> <200812192115.41068.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812192115.41068.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 09:15:40PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday 18 December 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > here's the first batch of conversion patches. Now ide_issue_pc/ide_transfer_pc
> > are almost completely aligned to their ide-cd counterparts
> > cdrom_start_packet_command/cdrom_transfer_packet_command. The only thing
> 
> Looks good generally but I need more time for detailed review.
> 
> [ Your super-quick action on this has caught me unprepared. ;) ]

sorry about that, it was all in good intentions :)

> > missing is the setting of the irq handler through ide_set_handler but this
> > is not that trivial since if i'd moved ide-cd's irq handler to ide-atapi
> > that would suck in a bunch of other ide-cd functions which is not what we
> > want, (yes/no)? and I'm going to have to ponder a little bit more on that.
> 
> Yes, we don't want to move them over.  In worst case we can add
> ide_handler_t *__old_pc_handler to ide_drive_t and set it in ide-cd
> (an acceptable hack this time) but there might be better options.

Can you believe that I was just experimenting with _exactly_ the same
option :). Patches coming on tomorrow hopefully and still before the
merge window.

By the way, you've posted a bunch of ide improvements/cleanups but
they're not on kernel.org yet. What's the plan with those, do you want
to upload them first and then I redo my patches or... ?

-- 
Regards/Gruss,
    Boris.
