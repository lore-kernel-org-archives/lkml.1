Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXGIK4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXGIK4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbXGIK4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:56:47 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:54496 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXGIK4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:56:46 -0400
Date: Mon, 9 Jul 2007 12:57:59 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070709105759.GL11451@enneenne.com>
References: <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org> <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <E1I7Shw-0003Em-4O@flower> <20070709091643.GF11451@enneenne.com> <20070709105611.GS3895@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709105611.GS3895@flower.upol.cz>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: Makefiles for GNU make (Re: [PATCH] LinuxPPS (with new
	syscalls API) - new version)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 12:56:11PM +0200, Oleg Verych wrote:
> On Mon, Jul 09, 2007 at 11:16:43AM +0200, Rodolfo Giometti wrote:
> > On Sun, Jul 08, 2007 at 11:05:32AM +0200, Oleg Verych wrote:
> > > * Rodolfo Giometti (Thu, 28 Jun 2007 18:14:50 +0200)
> > > * Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
> > > 
> > > > +.PHONY : all depend dep
> > > > +
> > > > +all : .depend $(TARGETS)
> > > > +
> > > > +.depend depend dep :
> > > > +	$(CC) $(CFLAGS) -M $(TARGETS:=.c) > .depend
> > > []
> > > > +# -- Clean section ------------------------------------------------------------
> > > > +
> > > > +.PHONY : clean
> > > > +
> > > > +clean :
> > > > +	rm -f *.o *~ core .depend
> > > 
> > > Please see how currently .PHONY targets are used correctly, e.g. in
> > > linux/Makefile.
> > 
> > I don't understand why you wish I use linux PHONY targets management
> 
> Sorry i was not clear. Problem is `GNU make'[0], not management.
> 
> [0] <http://article.gmane.org/gmane.comp.gnu.make.bugs/2481>
> 
> > in a documentation Makefile... I suppose you are talking about
> > linux/Documentation/pps/Makefile which is just an example about people
> > may compile some testing/debugging programs. :-o
> 
> So, after this example you may write correct Makefiles for `GNU make'.

I see... but I'm still a bit confused... if I well understand I should
change the Makefile as follow:

   diff --git a/Documentation/pps/Makefile b/Documentation/pps/Makefile
   index a2660a2..d766447 100644
   --- a/Documentation/pps/Makefile
   +++ b/Documentation/pps/Makefile
   @@ -6,7 +6,7 @@ CFLAGS += -ggdb
    
    # -- Actions section ---------------------------------------------------------- 
   -.PHONY : all depend dep
   +.PHONY : depend dep
    
    all : .depend $(TARGETS)
    
   @@ -20,8 +20,6 @@ endif
    
    # -- Clean section ------------------------------------------------------------ 
   -.PHONY : clean
   -
    clean :
           rm -f *.o *~ core .depend
           rm -f ${TARGETS}

Is that right?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
