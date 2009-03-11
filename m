Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZCKReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZCKReT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZCKReD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:34:03 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:36620 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCKReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=uzt1Yq35nxI5rBBkzeedLEZKhOvdIwxyoiPX15mOXog+y3jY8JE4Bz4wrky4TFzHmB
         OEuppQBiQSmNdpULbWywhTNFt/T4IwI9kT+XLpwXVm9edWS9mQtIM3Txu5j9FhRO0+DR
         xKwPZ8g3qugHU3a/2w1QveskZ+TLB1WXlzgpw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 08/10] ide: move ide_map_sg() call out from ->dma_setup method
Date: Wed, 11 Mar 2009 18:36:26 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-next-20090310; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <200903111736.26177.bzolnier@gmail.com> <49B7F074.2080807@ru.mvista.com>
In-Reply-To: <49B7F074.2080807@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903111836.27062.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>Move ide_map_sg() call from ->dma_setup implementations
> >>>and ide_destroy_dmatable() one from *_build_dmatable() to
> >>>ide_dma_prepare().
> 
> >>>There should be no functional changes caused by this patch.
> 
> >>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> >>[...]
> >>
> >>>Index: b/drivers/ide/au1xxx-ide.c
> >>>===================================================================
> >>>--- a/drivers/ide/au1xxx-ide.c
> >>>+++ b/drivers/ide/au1xxx-ide.c
> >>>@@ -272,9 +272,7 @@ static int auide_build_dmatable(ide_driv
> >>> 	if (count)
> >>> 		return 1;
> >>> 
> >>>- use_pio_instead:
> >>>-	ide_destroy_dmatable(drive);
> >>>-
> >>>+use_pio_instead:
> 
> >>   Could you please get rid of goto and label too, while at it?
> 
> > Sorry but since this patch has been already merged
> 
>     Merged where?!

To pata tree, two weeks ago.

I try to limit touching merged stuff as much as possible so people working
with pata tree don't get surprised too much (sometimes it is impossible but
this doesn't discourage me from trying).  

[ Some people may argue that existing stuff shouldn't change at all but
  IMO it is all case specific and this trade-off is acceptable for fixing
  regressions / preserving bisectability... ]

> > it would be too much work/noise for too little gain IMO.
> 
>     Will you take a reworked patch from me?

Well, OK this time if it won't cause rejects in later patches... though stuff
like that is really much more efficient done in incremental patches.

Thanks,
Bart
