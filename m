Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbYHFTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbYHFTi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYHFTiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:38:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:7669 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbYHFTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=jmV3Wh/dDInQdH7U1SB1BCmtQNlVYeCCDx1pHkFtq/v4YU9AWAEgCd2oEzLEVgcmhz
         8LVtK/wHmmhGFNtzrlkiktCFlCPoq5rvwwE/lgwz+p91C/3sbb7tX+762Ow5odxUHlE6
         bL88qwEd0dPj6VjCUYMHBiwCjNmH7h50n63BE=
Date: Wed, 6 Aug 2008 21:38:26 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/2] ide-{floppy,tape}: remove request stack
Message-ID: <20080806193826.GB31312@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808061914.06361.bzolnier@gmail.com> <58cb370e0808061133l724dc70do834ddcbc128af442@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cb370e0808061133l724dc70do834ddcbc128af442@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 08:33:24PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Wed, Aug 6, 2008 at 7:14 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> 
> [...]
> 
> > ---
> > pc stack can also be removed with a bit of care, we just need sth like:
> >
> > - add request_sense_pc (request_sense_rq alike)
> >
> > - dynamically allocate pc-s for blk_{fs,pc}_request() in ide-floppy.c
> >  and for REQ_IDETAPE_{READ,WRITE} in ide-tape.c
> >
> > - add PC_FLAG_DYN for dynamically allocated pc-s
> >
> > - (the difficult part) figure out where to put freeing of dynamic pc-s
> >
> > Borislav, AFAIR you had some patches doing dynamic pc/rq-s?
> > Maybe it would be possible to dust off just their rq-parts?
> 
> Please disregard above comments -- I found a better way to deal with rq stack.

Looks good so far, even slimmer than the dynamic alloc ones i'd done. Will test
with ide-floppy on the weekend.

-- 
Regards/Gruss,
    Boris.
