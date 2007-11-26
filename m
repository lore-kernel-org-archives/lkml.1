Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXKZIiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXKZIiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXKZIhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:37:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:46483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbXKZIhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:37:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gcz5iNSRHBAItp5jPliUvU64B8VJfXYd0uUhMjpEsu30KYPh3cx7xx3MgefSbATgNtd4v0TYCyOo2187qMIkhdFU5DPWnVVtSUqFWuQIoYczxVAFJJujsRfFwlg9MiSM4M9Z57j62gSzM4lMVE8XmgcYWMx9qdrFOv4Po6zod6w=
Message-ID: <91b13c310711260037o7af4b11dt389bb209a075c25a@mail.gmail.com>
Date: Mon, 26 Nov 2007 16:37:50 +0800
From: "rae l" <crquan@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH 2/2] ide-scsi: use print_hex_dump from <linux/kernel.h>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <1196062867.8948.25.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196061373-6394-1-git-send-email-crquan@gmail.com>
	 <1196062867.8948.25.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2007 3:41 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2007-11-26 at 15:16 +0800, Denis Cheng wrote:
> > diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
> > index 8d0244c..8f3fc1d 100644
> > --- a/drivers/scsi/ide-scsi.c
> > +++ b/drivers/scsi/ide-scsi.c
> > @@ -282,7 +272,7 @@ static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_co
> >       pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
> >       if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
> >               printk ("ide-scsi: %s: queue cmd = ", drive->name);
> > -             hexdump(pc->c, 6);
> > +             print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 6, 1);
> >       }
> >       rq->rq_disk = scsi->disk;
> >       return ide_do_drive_cmd(drive, rq, ide_preempt);
>
> Hi Denis.
>
> These aren't really equivalent.  You need to look at the
> line above to determine if a KERN_ prefix needs to be
> used at all.
>
> You should probably use print_hex_dump_bytes here.
I know this is different from the original hexdump in ide-scsi.c, I
just want to tell someone that there's a good implementation of
hexdump in kernel.h, and I think the default KERN_DEBUG and
print_hex_dump is more informative and has better output. However,
anyone want more precise control on debug message could make her/his
improvements with print_hex_dump.

>
> cheers, Joe
>
>

-- 
Denis Cheng
