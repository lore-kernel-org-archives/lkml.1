Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbXKOUxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbXKOUxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXKOUxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:53:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:19070 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763551AbXKOUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=F9DJ1QmiLEMfPQY/pZ6/qWc2rk0phyOtYTWpa3FBkuo8f/GZXRi68/sVs8OdOd+74i9ftEyTLpqCFNcvPlEL75Ov6lzJ9UBegowA9nT7mbo5DP2tKzJEkU8IAIftsMQqPRtTRDsH7jAq496TQZ9p11gtfKDBWd00mQKi37+uT6k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
Date: Thu, 15 Nov 2007 21:55:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Sebastian Kemper <sebastian_ml@gmx.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20071113164323.GA5252@section-eight> <20071114171139.GA9387@section-eight> <473B2EAA.4090802@rtr.ca>
In-Reply-To: <473B2EAA.4090802@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711152155.30719.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 14 November 2007, Mark Lord wrote:
> Sebastian Kemper wrote:
> > Hi Mark!
> > 
> > On Wed, Nov 14, 2007 at 11:41:37AM -0500, Mark Lord wrote:
> >> Ahh.. got it.  The host_status returned (not checked by that code) was 7,
> >> which means "host error".
> >>
> >> In this case, that's because the cmd_len is (16), which is too large for 
> >> ATAPI.
> >> It needs to be changed to (12) instead.
> > 
> > I don't understand. You seem to use a cmd_len of 16 in hdparm yourself.
> ..
> 
> Really?  Where?
> 
> 
> > And why does it work with the "old" ATA driver and not with libata if
> > 16 is too large for ATAPI in general?
> ..
> 
> Now that *is* the question.
> And the answer appears to be that ide-cd.c ignores the passed-in cmd_len,
> and replaces it with:
> 
>    cmd_len = COMMAND_SIZE(rq->cmd[0]);
> 
> That's a SCSI macro to calculate the correct cmd_len based on the SCSI opcode,
> which is very appropriate here.   We should do that too (we don't) in libata.
> 
> But not exactly as IDE does it -- that's actually a bug:  the code needs to also
> check that the new cmd_len is no larger than the original, or we'll get an Oops.
> 
> I'll cook up a patch for that shortly and try it before posting it here.

Could you please also fix ide-cd while at it?

Thanks,
Bart
