Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYHBSdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYHBSdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbYHBSc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:32:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:22446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYHBSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=sQbRUj9Zg0OmLM38I/euhF+HkQITho+fFu4301nLkFX0R+9oYrX7VEeh/se1ngjW9n
         cUc0zImns+r1JAPcuC0SifZCh7A4D3aEQNqMQCI2lym/2vW8mqKjZfqzarWa+aGUOAe7
         zb5bSCR6HO5MWYdLHjzrCxI1u3bBJ7wKgDrAM=
Date: Sat, 2 Aug 2008 20:32:53 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide-generic: skip automatic probing of legacy iobases
	(was: Re: [PATCH] ide-floppy fix)
Message-ID: <20080802183253.GA2239@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200807232051.12226.bzolnier@gmail.com> <20080801054831.GA14636@gollum.tnic> <200808021902.12191.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808021902.12191.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 07:02:12PM +0200, Bartlomiej Zolnierkiewicz wrote:

[.. ]

> Why not try <linux/ata.h> + inline trick instead?
> 
> [ <linux/ata.h> is shared by both stacks so by moving the function there
>   + making it inline it can also be shared without the need for dependency
>   on libata. ]

I hadn't thought of that, will try it out later.

> > As a result, i have now a new bool-Kconfig option BLK_DEV_GENERIC_ONLY which
> > gets reverse-selected only when no pci ide controller which is using the generic
> > ide_host_register() from within ide_pci_init_one() is selected in Kconfig. This
> > is tested both with and without a pci ide driver selected in addition to
> > ide-generic.
> 
> How's about just leaving the final decision up to the user with changing
> probe_mask in ide_generic from 0x3 to 0x0 and automatically probing for
> ports 0-1 iff there is no IDE PCI controller present (otherwise check
> probe_mask).

Wait, let me get this straight: you want to set probe_mask to 0x0 as a default,
which skips probing of the primary and secondary ports, and to do the checking
whether the IDE PCI controller uses legacy iobases only when the user has
enforced it by setting probe_mask to 0x3? At least this is how i understand
it...

> This is should remove the need for Kconfig magic and is a sane default
> since a lot of people get caught using ide_generic by mistake and not by
> intent (IOW they forgot to enable the right IDE PCI host driver).

[.. ]

-- 
Regards/Gruss,
    Boris.
