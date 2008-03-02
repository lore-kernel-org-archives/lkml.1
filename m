Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYCBVbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYCBVbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbYCBVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:31:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:39612 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbYCBVbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:31:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=hRt3FlwsIdQVcuH6Qy37sgRwh+tiv10ld4lkrEOCAvTFsic1/pFYSMH4CHC8x+oENJRRyGnaLEIDplI+cRw5Fc/ptdhMGny5R44DdnIoCgbzF0sEqtZIrNlKhozSM6UOjki4DDovskRIA3Dneh7DidwBOksMkBXrmh6+Ndm4DV4=
Date: Sun, 2 Mar 2008 22:31:26 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/24] ide-tape: remove pipeline-specific code from
	idetape_chrdev_write
Message-ID: <20080302213126.GF4836@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-5-git-send-email-petkovbb@gmail.com> <200803021941.28401.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803021941.28401.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 07:41:28PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 01 March 2008, Borislav Petkov wrote:
> > Also, remove unused stage-parameter from idetape_copy_stage_from_user()
> 
> Changes like this one are the best to put into separate patches
> at the very beginning of the patch series.
> 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-tape.c |   15 ++++-----------
> >  1 files changed, 4 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > index e919d41..4a064c1 100644
> > --- a/drivers/ide/ide-tape.c
> > +++ b/drivers/ide/ide-tape.c
> > @@ -1700,7 +1700,7 @@ static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
> >  }
> >  
> >  static int idetape_copy_stage_from_user(idetape_tape_t *tape,
> > -		idetape_stage_t *stage, const char __user *buf, int n)
> > +					const char __user *buf, int n)
> >  {
> >  	struct idetape_bh *bh = tape->bh;
> >  	int count;
> > @@ -2696,8 +2696,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
> >  
> >  	/* Initialize write operation */
> >  	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
> > -		if (tape->chrdev_dir == IDETAPE_DIR_READ)
> > -			idetape_discard_read_pipeline(drive, 1);
> 
> Why this is OK thing to do?
> 
> Are you sure that there are no hidden side-effects?
> 
> >  		if (tape->merge_stage || tape->merge_stage_size) {
> >  			printk(KERN_ERR "ide-tape: merge_stage_size "
> >  				"should be 0 now\n");
> > @@ -2729,8 +2727,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
> >  	}
> >  	if (count == 0)
> >  		return (0);
> > -	if (tape->restart_speed_control_req)
> > -		idetape_restart_speed_control(drive);
> 
> ditto
> 
> tape->restart_speed_control_req can still be non-zero.

Same as above: my main focus was ease of review and not keeping pipelining
functional at all times.

-- 
Regards/Gruﬂ,
    Boris.
