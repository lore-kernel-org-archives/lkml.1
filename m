Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZBGCYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZBGCYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZBGCYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:24:38 -0500
Received: from ozlabs.org ([203.10.76.45]:60506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZBGCYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:24:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer, not an array.
Date: Sat, 7 Feb 2009 12:54:28 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <200901290005.52819.rusty@rustcorp.com.au> <20090205160128.GA9486@mediacenter>
In-Reply-To: <20090205160128.GA9486@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071254.28824.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 02:31:28 Shawn Bohrer wrote:
> On Thu, Jan 29, 2009 at 12:05:52AM +1030, Rusty Russell wrote:
> > With allmodconfig (minus non-building modules) on 32-bit x86:
> > Total size of modules before: 60009790 bytes
> > Total size of modules after: 55927866 bytes
> > 
> > Saving 7% of module size for CONFIG_MODVERSIONS=y; and these sections
> > are kept resident as well.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  include/linux/module.h |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -37,10 +37,12 @@ struct kernel_symbol
> >  	const char *name;
> >  };
> >  
> > +/* This is put in the __versions section of a module to indicate the version
> > + * it expects for unknown symbols. */
> >  struct modversion_info
> >  {
> >  	unsigned long crc;
> > -	char name[MODULE_NAME_LEN];
> > +	char *name;
> >  };
> 
> Hey Rusty thanks for the change, but I just got around to testing this
> and I have a few observations/questions.  First this breaks:
> 
> modprobe --dump-modversions foo.ko

Hmm, that's an argument not to make this change.  Really, other than disk
space benefit we get all the benefits from just dropping the 
__versions section once loaded.

> I actually don't care, but just happened to stumble upon it when I also
> noticed that your changes seemed to be working a little too well.  I
> currently happen to be building my modules out of order for example
> module B depends on symbols from module A, but I build module B first.
> This means that the exported symbols are not in the Module.symvers file
> when module B is compiled.  I would expect module B to fail to load yet
> with your patches it magically works and I don't see any errors in the
> logs.

Interesting.  What is the value of /proc/sys/kernel/tainted?

And anyway, what was the symbol name which is over 56 characters long which
started this?

Thanks,
Rusty.
