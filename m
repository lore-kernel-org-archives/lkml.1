Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXELQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXELQAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXELQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:00:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55396 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXELQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:00:12 -0400
X-Originating-Ip: 72.143.66.196
Date: Sat, 12 May 2007 11:59:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: undefined "pm3fb_setup()"
In-Reply-To: <1178978268.4773.14.camel@daplas>
Message-ID: <Pine.LNX.4.64.0705121156300.15308@localhost.localdomain>
References: <Pine.LNX.4.64.0705120628250.11988@localhost.localdomain>
 <1178978268.4773.14.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007, Antonino A. Daplas wrote:

> On Sat, 2007-05-12 at 06:32 -0400, Robert P. J. Day wrote:
> >   i'm guessing someone's already spotted this but, with "make
> > allyesconfig" on x86:
> >
> > ...
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `pm3fb_init':
> > drivers/video/pm3fb.c:977: undefined reference to `pm3fb_setup'
> > ...
> >
> >   the reason seems to be this excerpt from drivers/video/pm3fb.c:
> >
> > ================================================================
> > int __init pm3fb_init(void)
> > {
> >         /*
> >          *  For kernel boot options (in 'video=pm3fb:<options>' format)
> >          */
> > #ifndef MODULE                       <-----------------------
> >         char *option = NULL;
> >
> >         if (fb_get_options("pm3fb", &option))
> >                 return -ENODEV;
> >         pm3fb_setup(option);
> > #endif
> >
> >         return pci_register_driver(&pm3fb_driver);
> > }
> >
> > static void __exit pm3fb_exit(void)
> > {
> >         pci_unregister_driver(&pm3fb_driver);
> > }
> >
> > #ifdef MODULE
>
> I've spotted this before, but forgotten about it.  Yes, the above should
> be #ifndef

ok, so is someone already fixing this?

rday
