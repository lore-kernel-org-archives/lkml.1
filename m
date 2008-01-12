Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYALVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYALVQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbYALVQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:16:08 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:34297 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757381AbYALVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:16:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=qvLeggrMSnVPG6gVzunuGZ+gORUHaD7dP61KlomcQnQybTSqRYfGyg9fJF4FEBO701SVN/4kHnUlTH3HfrH6vHcK0UJJoRA/H7jpGIjpLfCmCG/amNRrOWzazWt2eM8we83o+Xx5lwSH9ouOgieTtVKqbnbSNE1+NWuZe6zVhlI=  ;
X-YMail-OSG: OUY.bdcVM1m_VH2RmkxodqJjAJQ6o1zhKTd_o5EfKcMBSsqRrq9dTgTdBQmIt2bX1sA927_lJVjkJu7bXo91bf.YaRJKevGHwzwTz61tW5zVW1KbBQ--
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 12 Jan 2008 22:12:36 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 18/21] ide-floppy: fix error handling in
	idefloppy_probe()
Message-ID: <20080112211236.GC31954@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-18-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de> <200801122118.01949.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801122118.01949.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 09:18:01PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Friday 11 January 2008, Borislav Petkov wrote:
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > ---
> >  drivers/ide/ide-floppy.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> > index 89b26ea..0729df5 100644
> > --- a/drivers/ide/ide-floppy.c
> > +++ b/drivers/ide/ide-floppy.c
> > @@ -1737,7 +1737,8 @@ static int ide_floppy_probe(ide_drive_t *drive)
> >  				" emulation.\n", drive->name);
> >  		goto failed;
> >  	}
> > -	if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
> > +	floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL);
> > +	if (!floppy) {
> >  		printk(KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
> >  				" structure\n", drive->name);
> >  		goto failed;
> 
> I'm unable to see any problem with error handling here?

I changed it simply because checkpatch.pl complains so:

ERROR: do not use assignment in if condition (+ if ((floppy = kzalloc(sizeof(idefloppy_floppy_t), GFP_KERNEL)) == NULL))
#1740: FILE: home/boris/tmp/ide-floppy.c:1740:
+       if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL)
{

> This change should be combined with the rest of checkpatch.pl fixes.
ok.

-- 
Regards/Gruﬂ,
    Boris.
