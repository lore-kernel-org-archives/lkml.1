Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXJKOEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXJKOEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXJKOEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:04:24 -0400
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:20971 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752203AbXJKOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:04:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 10:04:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=r4Fxv8vl+1LXVb5yOGrDSVro6/aYCCQlqC1u3yDctAwlH2dp+vox5ElH2fEGfDFtrbr7LJzPF+waQXxmVkIl5rf6NkanfGXh3uHbgt+yzr2EYUjyzTpsYmgVMJrmgLi53Fl6HVa2P1oiY3exIdjvL33NcaAqcE7xxexzEGfk4Hc=;
X-YMail-OSG: GHhni.sVM1lvBMOt8VxcI.XD80D39UKC5wR7hwhwno_mdSrTZsHlC_wsHpm0J0XFJwy_XL3w8vVH8stfVt7Hp4UOM1DGjlPyW8MkvvTr7L2M8uJZrS2h3I2LRG_kHQ--
Date: Thu, 11 Oct 2007 06:57:42 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
To: Pierre Ossman <drzeus@drzeus.cx>, Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071010202223.292176a1@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <712072.37707.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus@drzeus.cx> wrote:

> On Wed, 10 Oct 2007 14:45:40 +0400
> Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > ["if (!x & y)" patch from yanzheng@]
> > ["if (!x & y)" patch from adobriyan@]
> > ["if (!x & y)" patches from viro@]
> > 
> > While we're at it, below is somewhat ugly sparse patch for detecting
> > "&& 0x" typos.
> > 
> 
> The maintainer for tifm is Alex Dubov, so cc:ing him.
> 
> > drivers/mmc/host/tifm_sd.c:183:9: warning: dubious && 0x
> > 
> > 	if ((r_data->flags & MMC_DATA_WRITE)
> >             && DATA_CARRY)
> > 		writel(host->bounce_buf_data[0],
> > 		host->dev->addr
> > 		+ SOCK_MMCSD_DATA);
> > 
> > 	given that DATA_CARRY is always used together with
> > ->cmd_flags, this place is asking for obvious fixlet:
> > 
> > 
> > [PATCH] tifm_sd.c: fix DATA_CARRY check
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> > ---
> > 
> >  drivers/mmc/host/tifm_sd.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/drivers/mmc/host/tifm_sd.c
> > +++ b/drivers/mmc/host/tifm_sd.c
> > @@ -180,7 +180,7 @@ static void tifm_sd_transfer_data(struct tifm_sd
> > *host) host->sg_pos++;
> >  			if (host->sg_pos == host->sg_len) {
> >  				if ((r_data->flags & MMC_DATA_WRITE)
> > -				    && DATA_CARRY)
> > +				    && (host->cmd_flags &
> > DATA_CARRY)) writel(host->bounce_buf_data[0],
> >  					       host->dev->addr
> >  					       + SOCK_MMCSD_DATA);
> > 
> > 
> > 
> 
> Rgds
> Pierre
> 

Oops. I wonder why this was never triggered (some users are having problems with dma, so they use
PIO rather extensively). The patch is probably correct, but I can't do any testing because I'm
currently on vacation.



      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


