Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYG2Ing@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYG2Ing (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYG2In2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:43:28 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:14537 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYG2In1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:43:27 -0400
Subject: Re: [patch 02/15] kmsg: Kernel message catalog script.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Michael Holzheu <holzheu@de.ibm.com>
In-Reply-To: <20080728192828.GA11431@uranus.ravnborg.org>
References: <20080728175355.734299984@de.ibm.com>
	 <20080728175511.260174666@de.ibm.com>
	 <20080728192828.GA11431@uranus.ravnborg.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 29 Jul 2008 10:42:30 +0200
Message-Id: <1217320950.10259.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 21:28 +0200, Sam Ravnborg wrote:
> > 
> > The kmsg man page creation is invoked with "make K=2" and reads the source
> > files for all built objects, looks up the message description and writes
> > a man page to $(objtree)/man.
> Can we use M=2 instead of K=?
> I have sort of reserved 'K' for Kconfig usage.

Ok, K= is taken but I can't use M= either because that is used for KBUILD_EXTMOD.
If tested with D= for "documentation", would that be okay ?

> > @@ -339,6 +341,19 @@ $(multi-used-m) : %.o: $(multi-objs-m) F
> >  
> >  targets += $(multi-used-y) $(multi-used-m)
> >  
> > +# kmsg check tool
> > +ifneq ($(KBUILD_KMSG_CHECK),0)
> > +  ifeq ($(KBUILD_KMSG_CHECK),2)
> > +    kmsg_cmd = print
> > +    quiet_cmd_force_check_kmsg = KMSG_PRINT $<
> > +    $(shell [ -d $(objtree)/man ] || mkdir -p $(objtree)/man)
> > +  else
> > +    kmsg_cmd = check
> > +    quiet_cmd_force_check_kmsg = KMSG_CHECK $<
> > +  endif
> > +  cmd_force_check_kmsg = SRCTREE=$(srctree) OBJTREE=$(objtree) \
> > +			$(KMSG_CHECK) $(kmsg_cmd) $(CC) $(c_flags) $< ;
> > +endif
> We are executing with $(objtree) as current directory so no need
> to specify $(objtree) in the above.

Ok, dropped $(objtree) from the shell command.

> You can used non-recursive assignments for kmsg_cmd (use ':=').

Will do.

> Do you really need the uppercase SRCTREE, OBJTREE?
> Other scripts uses the lower cases variants direct.

Ok, I'll fix the script to use srctree and objtree directly.

Thanks Sam.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


