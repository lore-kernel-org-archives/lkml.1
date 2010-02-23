Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0BWSht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:37:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56797 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0BWShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:37:47 -0500
X-Authority-Analysis: v=1.0 c=1 a=o9jgRAe6v1AA:10 a=7U3hwN5JcxgA:10 a=XWQXAzJ9s-tgdFUYx8sA:9 a=9zTrQETxWnfFYQRongPyGf06RQwA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <20100223182338.GC5836@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
	 <1266090518-31120-8-git-send-email-rabin@rab.in>
	 <1266931846.19540.9.camel@frodo>  <20100223182338.GC5836@debian>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Feb 2010 13:37:44 -0500
Message-ID: <1266950264.24271.6116.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 23:53 +0530, Rabin Vincent wrote:

> > > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > > index 0b94d2f..2535c11 100644
> > > --- a/scripts/Makefile.build
> > > +++ b/scripts/Makefile.build
> > > @@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
> > >  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> > >  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> > >  	"$(if $(CONFIG_64BIT),64,32)" \
> > > -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> > > +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> > > +	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> > 
> > Doesn't this need to be with the change of recordmcount.pl too?
> > Otherwise applying this patch alone will break it. We need every step of
> > the patches to work otherwise we risk breaking a kernel bisect.
> 
> Dynamic ftrace for ARM is only enabled in the last patch of the series,
> so this woudn't be breaking it.  No modification should be required for
> record_mcount.pl for other archs because this doesn't add/remove any
> parameters.

OK, it looked to me that "KBUILD_CFLAGS" was a separate parameter. I
miscounted my quotes. ;-)

-- Steve


