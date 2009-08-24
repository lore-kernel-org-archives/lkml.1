Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZHXIRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZHXIRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZHXIRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:17:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZHXIRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:17:32 -0400
Date: Mon, 24 Aug 2009 10:17:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Corey Minyard <minyard@acm.org>
Cc: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
       openipmi-developer@lists.sourceforge.net,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] [PATCH] char/impi: adding __init macro/
 fix of __exit macro location in ipmi_poweroff.c
In-Reply-To: <4A9204B4.2030800@acm.org>
Message-ID: <alpine.LNX.2.00.0908241017230.25797@wotan.suse.de>
References: <200908230146.56283.PeterHuewe@gmx.de> <4A9204B4.2030800@acm.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1040654244-1251101854=:25797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1040654244-1251101854=:25797
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 23 Aug 2009, Corey Minyard wrote:

> This is correct, I'm fine with it going through the trivial tree.  Thanks.
> 
> Acked-by: Corey Minyard <minyard@acm.org>
> 
> Peter Hüwe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> >
> > Trivial patch which adds the __init to the module_init function of
> > drivers/char/ipmi/ipmy_poweroff.c and corrects the location of __exit for
> > the
> > cleanup function.
> >
> > According to ldd3, page 31 the __exit token hast to be after the return
> > type.
> > Or am I getting something wrong here?
> >
> > Corey, please have a look at the small patch and either pull it through
> > your tree, or please ack' it so Jiri can pull it through the trivial tree.
> >
> > linux version 2.6.31-rc6 - linus git tree, So 23. Aug 01:38:43 CEST 2009
> >
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> > diff --git a/drivers/char/ipmi/ipmi_poweroff.c
> > b/drivers/char/ipmi/ipmi_poweroff.c
> > index a261bd7..2e66b5f 100644
> > --- a/drivers/char/ipmi/ipmi_poweroff.c
> > +++ b/drivers/char/ipmi/ipmi_poweroff.c
> > @@ -691,7 +691,7 @@ static struct ctl_table_header *ipmi_table_header;
> >  /*
> >   * Startup and shutdown functions.
> >   */
> > -static int ipmi_poweroff_init(void)
> > +static int __init ipmi_poweroff_init(void)
> >  {
> >   int rv;
> > 
> > @@ -725,7 +725,7 @@ static int ipmi_poweroff_init(void)
> >  }
> >  
> >  #ifdef MODULE
> > -static __exit void ipmi_poweroff_cleanup(void)
> > +static void __exit ipmi_poweroff_cleanup(void)
> >  {
> >   int rv;

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
--168427776-1040654244-1251101854=:25797--
