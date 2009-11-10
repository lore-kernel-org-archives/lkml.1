Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZKJPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZKJPwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbZKJPwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:52:33 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55990 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbZKJPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=bBxEKgcWz48rVqgNWJ4yJUyb+zu/geGUzH9/PYwQngNsYXY3WqFh5zxnEyNrfEkgeY
         RFPJ6ajU9Nfxe/txMf9EEr0uw/DMhowHPeKFfGLdNXWBxW/PDKmVdY8idmlCg8R7OEqx
         E/rRC89x7JCSp2J1HoU6ADmu/PFfneItVXUVw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
Date: Tue, 10 Nov 2009 16:51:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Thiago Farina <tfransosi@gmail.com>, jgarzik@pobox.com, mlord@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com> <4AF8F363.3010806@rtr.ca>
In-Reply-To: <4AF8F363.3010806@rtr.ca>
MIME-Version: 1.0
Message-Id: <200911101651.24912.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 November 2009 06:00:19 Mark Lord wrote:
> Thiago Farina wrote:
> > Use ARRAY_SIZE macro of kernel api instead.
> > 
> > Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> > ---
> >  drivers/ata/sata_mv.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> > index 6f5093b..a8a7be0 100644
> > --- a/drivers/ata/sata_mv.c
> > +++ b/drivers/ata/sata_mv.c
> > @@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
> >  	int err = 0;
> >  
> >  	ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
> > -	err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
> > +	err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
> >  	if (err)
> >  		return err;
> >  
> ..
> 
> What's the point of this ?
> 
> There is no "hardcoded array size" there to begin with,
> and using that silly macro obscures the actual calculation.
> 
> So now, instead of being able to verify correctness at a glance,

I kindly disagree here.  ARRAY_SIZE makes code smaller and prevents
subtle bugs in the more complex situations once you learn to always
use it.

[ Using ARRAY_SIZE you no longer have to verify anything and person
  looking at the code (which not necessarily is the original author)
  immediately knows what was the author's intention. ]

> I have to go off and research some silly macro and verify that
> it does the right thing.

You did it already and the macro name is quite descriptive so you
may as well just ACK the patch now.. ;)

-- 
Bartlomiej Zolnierkiewicz
