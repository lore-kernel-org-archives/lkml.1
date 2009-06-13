Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZFMSZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZFMSZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 14:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZFMSZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 14:25:42 -0400
Received: from mail2.shareable.org ([80.68.89.115]:32846 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZFMSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 14:25:41 -0400
Date: Sat, 13 Jun 2009 19:25:40 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Message-ID: <20090613182540.GJ16220@shareable.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org> <20090613161323.GC16220@shareable.org> <8bd0f97a0906130940j6b5e578bha8193f59d03c2f05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906130940j6b5e578bha8193f59d03c2f05@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Sat, Jun 13, 2009 at 12:13, Jamie Lokier wrote:
> > Mike Frysinger wrote:
> >> From: Jie Zhang <jie.zhang@analog.com>
> >>
> >> The Blackfin port has custom program header flags/addresses for
> >> automatically loading regions into the dedicated on-chip SRAM.  So add a
> >> hook for ports to leverage.
> >
> > What does this have to do with FDPIC?  I don't see anything that is
> > specific to FDPIC about this code, other than FDPIC being the type of
> > ELF used on Blackfin.  If an MMU were added to some future Blackfins,
> > wouldn't this code be used for non-FDPIC ELF too?
> 
> no, because with a MMU, the memory would be virtualized and we could
> handle it dynamically

Wouldn't you still want to put some things into local L1 SRAM, using thos, perhaps by
flagging it instead of

> > It looks like a way for certain special executables to load themselves
> > into fixed regions of the on-chip SRAM - and promptly crash if another
> > executable does the same.  Not so much a general executable format, as
> > a hack to load something specific which should only be done once at a
> > time.  What am I missing here?
> 
> the addresses are keys, not fixed and/or "real" addresses

Oh, I see that is indeed quite nice :-)

I see it checks for both flags and special address values.  Are the
special address checks mainly historical, as usually flags/types are
used to designate special memory types in ELF.

Anyway,

Acked-By: Jamie Lokier <jamie@shareable.org>

-- Jamie
