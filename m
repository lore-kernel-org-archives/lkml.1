Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbYA3SG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbYA3SG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYA3SGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:06:18 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5910 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbYA3SGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:06:17 -0500
Date: Wed, 30 Jan 2008 19:06:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080130180613.GU15220@kernel.dk>
References: <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk> <Pine.LNX.4.64.0801301125350.26562@vixen.sonytel.be> <20080130103803.GN15220@kernel.dk> <1201703915.3292.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201703915.3292.1.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008, James Bottomley wrote:
> On Wed, 2008-01-30 at 11:38 +0100, Jens Axboe wrote:
> > On Wed, Jan 30 2008, Geert Uytterhoeven wrote:
> > > On Tue, 29 Jan 2008, Jens Axboe wrote:
> > > > On Tue, Jan 29 2008, Jens Axboe wrote:
> > > > > On Tue, Jan 29 2008, James Bottomley wrote:
> > > > > > On Tue, 2008-01-29 at 11:10 -0800, Matthew Dharm wrote:
> > > > > > > For some reason, usb_sg_init is boned during auto-sense.
> > > > > > 
> > > > > > OK, that's implicating the scsi_eh_prep_cmnd() in the auto sense
> > > > > > code ... that was also an update in 2.6.24
> > > > > 
> > > > > yeah, already found the bug - it's assuming ->request_buffer holds the
> > > > > sglist, oops. Preparing a fix.
> > > > 
> > > > ok here goes, this saves and restores the sg table correctly. it also
> > > > fixes the usb bug for me.
> > > 
> > > I can confirm this patch fixes the errors I was seeing with current
> > > linux-2.6.git for the USB memory card readers in a Dell TFT connected
> > > to a PS3.
> > 
> > James, we need a fix for this pushed asap. So either we should merge the
> > below now, or push the bidi patchset that also fixes this. It all
> > depends on when you want to merge the bidi patches...
> 
> The SCSI patch set (including the bidirectional pieces) is waiting in
> scsi-misc ... just for forms sake, could you confirm that it actually
> fixes the problem and I'll push it.

Certainly, I'll give it a spin tonight.

-- 
Jens Axboe

