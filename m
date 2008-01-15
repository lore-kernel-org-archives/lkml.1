Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYAOHL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYAOHL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 02:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYAOHLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 02:11:18 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:24147 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751733AbYAOHLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:11:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Vkmm4aSTeSwWnZM9XinWobKzylzDfoIQUycYY5RQXfwCInKOjivgxphfEsiPzyaKWjT81d8RS9F52S7eADG8knOFvbPkCg13pm8Y+pSMyCOayvsrDrrQjKMKMxNkWZMKKnZsP4ZONnGnPs6l22Bt50acBVXZkR0hm6G3hd+LC5M=  ;
X-YMail-OSG: L7xQYyEVM1mctFI5wskZaSdAsqyiICx91Nqjqsnu3D1G6jAA
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 15 Jan 2008 08:07:35 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Message-ID: <20080115070735.GA32009@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-10-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de> <200801142250.58201.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801142250.58201.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:50:58PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 13 January 2008, Borislav Petkov wrote:
> > ..and replace them with flag enums.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > ---
> >  drivers/ide/ide-floppy.c |  132 +++++++++++++++++++++++++--------------------
> >  1 files changed, 73 insertions(+), 59 deletions(-)
> 
> [...]
> 
> > @@ -506,14 +516,14 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
> >  
> >  	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
> >  
> > -	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
> > +	if (PC_FLAG_DMA_IN_PROGRESS & pc->flags) {
> 
> the usual kernel convention is to put flag last, i.e.
> 
> pc->flags & PC_FLAG_DMA_IN_PROGRESS
> 
> [...]
> 
> > @@ -570,7 +581,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
> >  		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __FUNCTION__);
> >  		return ide_do_reset(drive);
> >  	}
> > -	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
> > +	if (((ireason & IO) == IO) == (PC_FLAG_WRITING  & pc->flags)) {
> 
> - test_bit() returns 1 or 0 (=> boolean)
> - (pc->flags & PC_FLAG_WRITING) is 0x10 or 0
> 
> so the above comparison will fail
> 
> > @@ -607,7 +618,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
> >  		xferfunc(drive, pc->current_position, bcount);
> >  	else
> >  		ide_floppy_io_buffers(drive, pc, bcount,
> > -				test_bit(PC_WRITING, &pc->flags));
> > +				(PC_FLAG_WRITING & pc->flags));
> 
> ditto, this may actually work but '(pc->flags & PC_FLAG_WRITING) ? 1 : 0'
> would be much safer from maintainability POV
Hi Bart,

i must've been sleeping while i've been doing this :) Will redo them tonight and
resend.

Thanks.
-- 
Regards/Gruﬂ,
    Boris.
