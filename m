Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZFTLz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZFTLz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFTLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:55:18 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56667 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZFTLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=aaEOT3IzjSKkdLtgILNTyZypO8GUCHj+us5E2mJCssDDvH4adqmAVxcsOkuaDH0YKz
         LmwmbGk4/Ah8+Q1RG/z02Ep6sp3m2FDDeVZ6FpHwkBOgYSW6rRBQ7cbhM7IOxnXdGrQi
         xmepvj1vCHK7EkCLUl2G9StbZ3/WwgCsET4aI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
Date: Sat, 20 Jun 2009 12:27:31 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: Rainer Weikusat <rweikusat@mssgmbh.com>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>, bruinjm@xs4all.nl
References: <87zlc58xgd.fsf@fever.mssgmbh.com> <87r5xh8ty7.fsf@fever.mssgmbh.com> <9ea470500906180906o2d558a90hbcba11874ff8917b@mail.gmail.com>
In-Reply-To: <9ea470500906180906o2d558a90hbcba11874ff8917b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906201227.36253.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 June 2009 18:06:34 Borislav Petkov wrote:
> Hi,
> 
> On Thu, Jun 18, 2009 at 5:04 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> > From: Rainer Weikusat <rweikusat@mssgmbh.com>
> >
> > With 2.6.30, the error handling code in cdrom_newpc_intr was changed
> > to deal with partial request failures by normally completing the 'good'
> > parts of a request and only 'error' the last (and presumably,
> > incompletely transferred) bio associated with a particular
> > request. In order to do this, ide_complete_rq is called over
> > ide_cd_error_cmd() to partially complete the rq. The block layer
> > does partial completion only for requests with bio's and if the
> > rq doesn't have one (eg 'GPCMD_READ_DISC_INFO') the request is
> > completed as a whole and the drive->hwif->rq pointer set to NULL
> > afterwards. When calling ide_complete_rq again to report
> > the error, this null pointer is derefenced, resulting in a kernel
> > crash.

Rainer, thanks for fixing this bug (with a lot of extra points for
the detailed explanation).

> @Bart: please apply.

applied [I kept the above patch description]
