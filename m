Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZDDMRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZDDMRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZDDMRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:17:13 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:33793 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZDDMRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Hr1JH3glXT/MY5frccIotshzvrLCnYxDWGfcMbF7Hem0e8Fj3fPn48PtLm984AILwV
         hRB+h/s+ypDZZIv0pZX4hx8FYDFMqWToDi8tgOs+G6Iw1cbw0NTfpeMFlTee+H33p/Rx
         Q45x4zt39E+moEWlL5d6auUV+Cx3TJ+ud3BFU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Date: Sat, 4 Apr 2009 14:17:20 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238655519-10074-2-git-send-email-petkovbb@gmail.com> <200904030108.39927.bzolnier@gmail.com> <20090403045803.GA3732@liondog.tnic>
In-Reply-To: <20090403045803.GA3732@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904041417.21125.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Borislav Petkov wrote:

[...]

> > > @@ -614,14 +589,15 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
> > >  	struct request *rq = hwif->rq;
> > >  	ide_expiry_t *expiry = NULL;
> > >  	int dma_error = 0, dma, thislen, uptodate = 0;
> > > -	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
> > > +	int write, uninitialized_var(rc), nsectors;
> > 
> > Why is uninitialized_var() here now?
> 
> because gcc is whining that it might be uninitialized although I've
> doublechecked all codepaths returning a valid error. It is there to shut
> up this warning, actually.

It is gcc's fault (version dependent on top of it).  However since it may
affect other people and workarounding it costs us absolutely nothing lets
be pragmatic about it.

Please resend this change in a separate patch so it can be applied.
