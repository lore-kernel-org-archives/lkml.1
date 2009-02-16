Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZBPVyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZBPVyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZBPVyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:54:04 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:6637 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbZBPVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=PLffxMKwfo3NdpVD6vm3YOFGq4iXHhZLF7OpAP52uZ4SDTuMEltRouiA6V202XDyzs
         0p5MkZEQFwhervwthaCHu52I2rHPl4rHqrK5nW6YgXo8hV2KjoH1LeH+PBagI3+n4v9t
         khQRwdVuplVRG73ZYxZrYS+LtxF49rcm77VHo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 11/20] ide-cd: unify cdrom_newpc_intr() exit paths
Date: Mon, 16 Feb 2009 22:09:21 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-next-20090213; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain> <20090216001422.27491.17281.sendpatchset@localhost.localdomain> <20090216092501.GA24323@gollum.tnic>
In-Reply-To: <20090216092501.GA24323@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162209.21827.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Borislav Petkov wrote:
> On Mon, Feb 16, 2009 at 01:14:22AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide-cd: unify cdrom_newpc_intr() exit paths
> > 
> > * Move cdrom_end_request() calls from cdrom_decode_status()
> >   and ide_cd_check_ireason() to cdrom_newpc_intr().
> > 
> > * Unify cdrom_newpc_intr() exit paths.
> > 
> > There should be no functional changes caused by this patch.
> > 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-cd.c |   48 +++++++++++++++++++++++-------------------------
> >  1 file changed, 23 insertions(+), 25 deletions(-)
> > 
> > Index: b/drivers/ide/ide-cd.c
> > ===================================================================
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -291,7 +291,8 @@ static void cdrom_end_request(ide_drive_
> >  /*
> >   * Returns:
> >   * 0: if the request should be continued.
> > - * 1: if the request was ended.
> > + * 1: if the request will be going through error recovery.
> > + * 2: if the request should be ended.
> 
> Yeah, we need defines for those. Especially if they're checked in other
> functions:
> 
> if (rc == 2)
> 
> is simply not ok :). Rather,
> 
> if (rc == DO_END_REQUEST)
> 
> or something like that is much better, imho.

The whole cdrom_decode_status() needs a rewrite.  It could be as well
that after that happens magic defines won't be needed anylonger...

Thanks,
Bart
