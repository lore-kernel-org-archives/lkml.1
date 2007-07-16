Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbXGPWRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbXGPWRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbXGPWQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:16:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43748 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbXGPWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:16:53 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 16 Jul 2007 18:14:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yoann Padioleau <padator@wanadoo.fr>, linux-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] potential parse error, drivers/serial/dz.h
In-Reply-To: <20070716150421.c21d38c5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707161812390.12891@localhost.localdomain>
References: <87k5t05r4a.fsf@wanadoo.fr> <20070716150421.c21d38c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Andrew Morton wrote:

> On Mon, 16 Jul 2007 17:02:13 +0200
> Yoann Padioleau <padator@wanadoo.fr> wrote:
>
> >
> > potential parse error in declaration under a #ifdef.
>
> A certain parse error, I'd say.  How come nobody is reporting it?
>
> > Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
> >
> >
> > diff --git a/drivers/serial/dz.h b/drivers/serial/dz.h
> > index 9674d4e..9141c37 100644
> > --- a/drivers/serial/dz.h
> > +++ b/drivers/serial/dz.h
> > @@ -125,8 +125,8 @@ #define DZ_XMIT_SIZE   4096
> >  #define DZ_WAKEUP_CHARS   DZ_XMIT_SIZE/4
> >
> >  #ifdef MODULE
> > -int init_module (void)
> > -void cleanup_module (void)
> > +int init_module (void);
> > +void cleanup_module (void);
> >  #endif
> >
> >  #endif /* DZ_SERIAL_H */
>
> I don't think these symbols are actually implemented in anything
> which uses this header.  If they _do_ exist then they are awfully
> named and should be renamed ASAP.  Or they should be made static.
>
> However I suspect they just don't exist, and this stuff should be
> simply deleted.

that header file is included only by drivers/serial/dz.c, whose
Kconfig controlling setting is:

config SERIAL_DZ
        bool "DECstation DZ serial driver"
	...

so, since it's "bool," there's no way "#ifdef MODULE" can ever be
true, yes?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
