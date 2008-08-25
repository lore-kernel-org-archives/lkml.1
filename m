Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYHYUc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYHYUc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYHYUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:32:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:58404 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYHYUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=dpb0cIrx3IlAwgTwXt7EV0PvlZEXNCx1m1dWR4MFzc5jBui+EA/ZpExJ1pBhLtgLNm
         yRPEKRq1YDqEPSeUaViEsJC07Vk6eXgfzXxfA7o8lIUhkRiFu34R+kZc/zsSL+9eGkZd
         MCXk5Hy7SVz3ahX8VuHNKm3iKaSMPNPJup+hI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/9] ide-disk: set_addressing() fixes
Date: Mon, 25 Aug 2008 22:23:54 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain> <20080817171501.27943.57473.sendpatchset@localhost.localdomain> <48B0850D.4000105@ru.mvista.com>
In-Reply-To: <48B0850D.4000105@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808252223.54795.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Return -EIO if arg > 0 and LBA48 is unsupported.
> >
> > * No need to reset ->addressing.
> >
> > * Make ->addressing a single bit flag.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> [...]
> > Index: b/include/linux/ide.h
> > ===================================================================
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> > @@ -507,7 +507,7 @@ struct ide_drive_s {
> >  	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
> >  	unsigned post_reset	: 1;
> >  	unsigned udma33_warned	: 1;
> > -	unsigned addressing	: 2;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
> > +	unsigned addressing	: 1;	/* 0=28-bit, 1=48-bit */
> >  	unsigned wcache		: 1;	/* status of write cache */
> >  	unsigned nowerr		: 1;	/* used for ignoring ATA_DF */
> >   
> 
>    Don't you want to get rid of things like:
> 
>         u8 lba48 = (drive->addressing == 1) ? 1 : 0;

This was dealt with in "[PATCH 5/9] ide: add device flags" - since patch
#5/9 was going to touch the code anyway and there were no benefits besides
aesthetics in doing it in #2/9 I optimized the development process a bit...
