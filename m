Return-Path: <linux-kernel-owner+w=401wt.eu-S1763924AbZDISmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763924AbZDISmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZDISlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:41:47 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:48868 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756295AbZDISlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:41:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=m3QaXO+J1eBYFlrkNxUVGMOYWSISB0d5OuVEqVj7b7xfrNj1uS/nWflR/Cpve5ao/THPwWuruCyBIw+f5Srubx/r1cTMHePlVwadmAZL2DZ8o9RhQfIrE+/p1j+RM2rrClw/vI6SbnxopZCLBp/K+Anne8rg79S3aPnlVO9+Qms=;
Message-ID: <112180.11800.qm@web50107.mail.re2.yahoo.com>
X-YMail-OSG: z.MuUiAVM1lKdqRaWidOrYah3rCfxLBcZumZEfotskLwAlxIhzxC.iXMpdAA05IaS7O1feFp75gohhO.Wm3LW.fvss8g9P_yereSZod_uHzxXZfOkccoytp1W0OaTXpvTfWWP5yX2BWL4GiMhKbAMGlj2cDA3Tfa8SUl.5xoc0Ugy92ehZG1KoDktspSXR9yYVMW67h0iesV1sT5UrLnl0B6EgMZWeUut2.A9vXcmIkkn8_cTYjG0O_AP1cx40gR7uJaSnbUcO_VXQzPOzCYMLXMT.SbUJOirTt_kPWz3DVhr_63uWPCZTFrwXMSL69M
X-Mailer: YahooMailClassic/5.2.15 YahooMailWebService/0.7.289.10
Date: Thu, 9 Apr 2009 11:41:44 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] x86,edac: fix for compiler error in traps.c
To: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 4/8/09, Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [PATCH] x86,edac: fix for compiler error in traps.c
> To: "Steven Rostedt" <rostedt@goodmis.org>
> Cc: "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>, "Doug Thompson" <norsk5@yahoo.com>
> Date: Wednesday, April 8, 2009, 6:48 PM
> On Wed, 8 Apr 2009 20:06:53 -0400
> (EDT) Steven Rostedt <rostedt@goodmis.org>
> wrote:
> 
> > 
> > Impact: compile fix
> > 
> >  I got this compile failure on both
> tip/tracing/core as well as on 
> >  v2.6.30-rc1.
> >  
> >    LD      .tmp_vmlinux1
> >  arch/x86/kernel/built-in.o: In function
> `do_nmi':
> >  (.text+0x3c18): undefined reference to
> `edac_handler_set'
> >  arch/x86/kernel/built-in.o: In function
> `do_nmi':
> >  (.text+0x3c48): undefined reference to
> `edac_atomic_assert_error'
> >  make: *** [.tmp_vmlinux1] Error 1
> >  [root@bxrhel51 linux-trace.git]# grep
> edac_handler_set 
> >  [root@bxrhel51 linux-trace.git]# Grep
> edac_handler_set '*.[ch]'
> >  find .  -name "*.[ch]" ! -type d  |
> xargs grep  "edac_handler_set"
> >  ./arch/x86/kernel/traps.c:    if
> (edac_handler_set()) {
> >  ./include/linux/edac.h:extern int
> edac_handler_set(void);
> >  ./drivers/edac/edac_stub.c:int
> edac_handler_set(void)
> > 
> ./drivers/edac/edac_stub.c:EXPORT_SYMBOL_GPL(edac_handler_set);
> >  
> > This patch seems to fix it.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > diff --git a/drivers/edac/Makefile
> b/drivers/edac/Makefile
> > index a5fdcf0..cc2bcb4 100644
> > --- a/drivers/edac/Makefile
> > +++ b/drivers/edac/Makefile
> > @@ -7,7 +7,7 @@
> >  #
> >  
> >  
> > -obj-$(CONFIG_EDAC)   
>         := edac_stub.o
> > +obj-$(CONFIG_EDAC)   
>         += edac_stub.o
> >  obj-$(CONFIG_EDAC_MM_EDAC)   
>     += edac_core.o
> >  
> >  edac_core-objs    := edac_mc.o
> edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o
> 
> OK, thanks, I'll send that Linuswards asap.
> 
> I guess it could/should be
> 
>     obj-y += edac_stub.o
> 
> because CONFIG_EDAC is known to be true in
> drivers/edac/.  But that's
> just a consistency/style thing for Doug to scratch his head
> over ;)

I had determined (long ago) that := was a first instance initialization. I could be (probably was) wrong on that. I saw that in other files as well as reading the docs (me read em?).

edac_stub.o is targeted to be IN the kernel via the CONFIG_EDAC object file, since that is a boolean switch. It is a different builtin lib from the modules of edac. It is a relay set of functions and interfaces.

thanks for checking up on it

doug t

