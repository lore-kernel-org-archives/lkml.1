Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYFVN55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYFVN55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 09:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYFVN5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 09:57:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:43029 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYFVN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 09:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=izzhWF3zhU5C8ot45tLwoocCBarK7OP1QR42z80kcNxzVOjruSh9Jl7cO8720OkrWk
         a0wrAMDqMEtzqVVIxtn13OOymNWaPzoMWbQo1orrcU4zJstUnOOs4WD5qr/zpwIfeu9p
         RHEHS0Ar9AY+VoqZqohosooJitV8VnEEkg90Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] fix BLK_DEV_HD_ONLY on ARM dependencies
Date: Sun, 22 Jun 2008 15:21:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080609222155.GA1987@cs181133002.pp.htv.fi> <200806101956.15711.bzolnier@gmail.com> <20080622101752.GG27069@cs181133002.pp.htv.fi>
In-Reply-To: <20080622101752.GG27069@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806221521.33506.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008, Adrian Bunk wrote:
> On Tue, Jun 10, 2008 at 07:56:15PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 10 June 2008, Adrian Bunk wrote:
> > > This patch limits BLK_DEV_HD_ONLY to the ARM platforms offering 
> > > IRQ_HARDDISK, fixing the following compile error on others:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > >   CC      drivers/ide/legacy/hd.o
> > > ...
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'hd_times_out':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: (Each undeclared identifier is reported only once
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: for each function it appears in.)
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'do_hd_request':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:661: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'hd_init':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:765: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> > > make[3]: *** [drivers/ide/legacy/hd.o] Error 1
> > > 
> > > <--  snip  -->
> > > 
> > > Reported-by: Adrian Bunk <bunk@kernel.org>
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > applied, thanks
> > 
> > BTW Could you look into converting your "remove BLK_DEV_HD_ONLY" patch
> > into "move old hd driver to drivers/block/" one because the old hd driver
> > still has some uses (as noticed by Alan)?
> 
> drivers/ide/Makefile says:
>   # old hd driver must be last
> 
> Is this still true?

Yep.

> If yes then moving the driver to drivers/block/ requires switching to 
> late_initcall() since drivers/block/ is linked before drivers/ide/ .

Care to cook a patch?

Thanks,
Bart
