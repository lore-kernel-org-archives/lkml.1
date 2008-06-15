Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYFOJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYFOJ20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 05:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbYFOJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 05:28:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:14922 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbYFOJ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 05:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=YyIgI2VCxlsBWKHBea9WJmy/+811CGtV/od6fIC0aMuvR8KhM/SoJ01ECt3peYTRmk
         JYHnrqiayRu3b7CBZmDwUA1a9Ye9A05RGhRU6BF8fu5UPuU4Q7IgcJpuEqXyFG6CyFdo
         aEX6ajJUmNRDCimwBNk5woyaB2E92QXw+1wcg=
Date: Sun, 15 Jun 2008 11:28:08 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/18] ide-cd: remove ide_cd_drain_data and
	ide_cd_pad_transfer
Message-ID: <20080615092808.GA7622@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-3-git-send-email-petkovbb@gmail.com> <200806141929.05834.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806141929.05834.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 07:29:05PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 12 June 2008, Borislav Petkov wrote:
> > Use the generic ide_pad_transfer() helper instead
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> applied w/ ide_cd_drain_data() -> ide_pad_transfer() conversion fixup
> 
> [...]
> 
> > @@ -1006,7 +981,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
> >  					   - bio_cur_sectors(rq->bio),
> >  					   thislen >> 9);
> >  			if (nskip > 0) {
> > -				ide_cd_drain_data(drive, nskip);
> > +				ide_pad_transfer(drive, write, nskip);
> >  				rq->current_nr_sectors -= nskip;
> >  				thislen -= (nskip << 9);
> >  			}
> 
> ide_cd_drain_data() took number for _sectors_ as an argument
> while ide_pad_transfer() wants to be given number of _bytes_

/me crawls ashamed back into the black place behind the wall cardboard ... :)
> 
> > @@ -1043,7 +1018,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
> >  				 * If the buffers are full, pipe the rest into
> >  				 * oblivion.
> >  				 */
> > -				ide_cd_drain_data(drive, thislen >> 9);
> > +				ide_pad_transfer(drive, 0, thislen >> 9);
> 
> ditto

-- 
Regards/Gruﬂ,
    Boris.
