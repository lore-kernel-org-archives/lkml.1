Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYBGLPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYBGLPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 06:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbYBGLO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 06:14:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:42123 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYBGLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 06:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s6mw9cZvHW2FTqrxSuiYx4SayFI1rn+9Y9mKuXgtFiQMuGDt3esWB+ZjX6lJ/7i+2BqU+yoHKg3wycXNq1el7m/uifpPh10VTAqrRY2Fz/QixACJpOr3w8I7K/VhXlEyZGpeFUHV0iXG09vugq40HfGaLdP2qc+bwo7UrbzvAao=
Message-ID: <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
Date: Thu, 7 Feb 2008 12:14:56 +0100
From: "Harald Arnesen" <skogtun.linux@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Latest git oopses during boot
Cc: "FUJITA Tomonori" <tomof@acm.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matthew Wilcox" <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080207020214.0f0cf1c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
	 <20080206144732.5a1a2c3b.akpm@linux-foundation.org>
	 <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
	 <20080207020214.0f0cf1c7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> (cc's restored, and expanded a bit)

Ah, sorry, not used to gmail's web interface. Clicked the wrong button.

> > Seems to be the advansys driver, so I tried to remove it - and indeed,
> > the kernel now boots. So I guess it's either that driver or my ancient
> > Nikon Coolscan II that is the only thing attached to the board.
>
> Thanks.  I uploaded the oops picture to
> http://userweb.kernel.org/~akpm/oops.jpg
>
> > Cc to the Matthew Wilcox added.
>
> mm...  looks like all Matthew's changes were in 2.6.23.  And 2.6.23 worked
> OK, yes?

Both 2.6.23 and 2.6.24 are ok.

> The only recent changes to drivers/scsi/advansys.c are
>
> commit b80ca4f7ee36c26d300c5a8f429e73372d153379
> Author: FUJITA Tomonori <tomof@acm.org>
> Date:   Sun Jan 13 15:46:13 2008 +0900
>
>     [SCSI] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
>
>     This replaces sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in
>     several LLDs. It's a preparation for the future changes to remove
>     sense_buffer array in scsi_cmnd structure.
>
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> :100644 100644 9dd3952... 492702b... M  drivers/scsi/advansys.c
>
> commit 747d016e7e25e216b31022fe2b012508d99fb682
> Author: Randy Dunlap <randy.dunlap@oracle.com>
> Date:   Mon Jan 14 00:55:18 2008 -0800
>
>     advansys: fix section mismatch warning
>
>     Fix section mismatch warning:
>
>     WARNING: vmlinux.o(.exit.text+0x152a): Section mismatch: reference to .init.
>
>     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>     Cc: Matthew Wilcox <willy@debian.org>
>     Cc: James Bottomley <James.Bottomley@steeleye.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> which seem fairly benign.
>
>
> gcc inlining is going to make it rather a lot of work to find out which
> statement has actually oopsed there.
-- 
Hilsen Harald
