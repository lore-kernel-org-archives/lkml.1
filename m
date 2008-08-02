Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYHBSs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYHBSs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYHBSsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:48:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:18323 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYHBSsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HM5Z7RyVid7Xpp2UnsjujiHEqXWGkn3V8z0bi5ryeBLm08ItSOTl9WARbBlOhSgD9b
         G9SznDrR7z21OidZyDgundzxyD/E76LAMDu12/vwC3y74TON5K0re2qgwcIjiyjh7pHR
         qZ91S1qXoWbFjsDusZ5xsR7MzQ4WbVk5m29XY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-generic: skip automatic probing of legacy iobases (was: Re: [PATCH] ide-floppy fix)
Date: Sat, 2 Aug 2008 20:46:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808021902.12191.bzolnier@gmail.com> <20080802183253.GA2239@gollum.tnic>
In-Reply-To: <20080802183253.GA2239@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808022046.16990.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008, Borislav Petkov wrote:
> On Sat, Aug 02, 2008 at 07:02:12PM +0200, Bartlomiej Zolnierkiewicz wrote:

[...]

> > > As a result, i have now a new bool-Kconfig option BLK_DEV_GENERIC_ONLY which
> > > gets reverse-selected only when no pci ide controller which is using the generic
> > > ide_host_register() from within ide_pci_init_one() is selected in Kconfig. This
> > > is tested both with and without a pci ide driver selected in addition to
> > > ide-generic.
> > 
> > How's about just leaving the final decision up to the user with changing
> > probe_mask in ide_generic from 0x3 to 0x0 and automatically probing for
> > ports 0-1 iff there is no IDE PCI controller present (otherwise check
> > probe_mask).
> 
> Wait, let me get this straight: you want to set probe_mask to 0x0 as a default,
> which skips probing of the primary and secondary ports, and to do the checking

Yes.

> whether the IDE PCI controller uses legacy iobases only when the user has
> enforced it by setting probe_mask to 0x3? At least this is how i understand
> it...

Nope, always do the checking and if there is no IDE PCI controller do the
probing (& if there is IDE PCI controller present check probe_mask bits).
