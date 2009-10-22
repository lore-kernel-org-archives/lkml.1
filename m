Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZJVSiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZJVSiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZJVSiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:38:08 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59041 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbZJVSiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:38:07 -0400
Date: Thu, 22 Oct 2009 20:38:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephan von Krawczynski <skraw@ithnet.com>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: include/asm-generic/int-ll64.h kernel 2.6.31.4
Message-ID: <20091022183810.GA1227@merkur.ravnborg.org>
References: <20091020154305.8338b765.skraw@ithnet.com> <200910221629.59818.arnd@arndb.de> <20091022182106.3bdf7b5d.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022182106.3bdf7b5d.skraw@ithnet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tuesday 20 October 2009, Stephan von Krawczynski wrote:
> > > I lately compiled some app that stumbled across this, and someone smarter than
> > > me should judge if this is right or wrong:
> > > 
> > > 
> > > * asm-generic/int-ll64.h
> > >  *
> > >  * Integer declarations for architectures which use "long long"
> > >  * for 64-bit types.
> > >  */
> > > 
> > > #ifndef _ASM_GENERIC_INT_LL64_H
> > > #define _ASM_GENERIC_INT_LL64_H
> > > 
> > > #include <asm/bitsperlong.h>
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > 
> > > Is it correct to include from linked "asm" instead of asm-generic ?
> > > 
> > > My link goes to "asm-x86" but for some reason asm-generic/types.h is included
> > > which ends at int-ll64.h trying to include a not existing bitsperlong.h from
> > > directory asm-x86.
> > 
> > Hi Stephan,
> > 
> > Most likely you are using the kernel headers in an unsupported way, like
> > trying to point to $(HOME)/linux-2.6/include for include files when building
> > an application.
> > 
> > Please see http://kernelnewbies.org/KernelHeaders for how to fix that.
> > 
> > 	Arnd <><
> 
> I am the wrong person to tell that, the story belongs to keepalived.
keepalived - thats the application you try to build?
Check your settings of CFLAGS and do so for keepalivd too.
As Arnd tells you yhe wong kernel headers are used.
We cannot fix that for you - but you can patch it yourself or
ask keepalived folks to do so.


> Nevertheless reading other header files in the same dir makes me think that
> pointing to "asm" instead of "asm-generic" looks flakey, or why do others
> point to -generic then?
Look closer...
that file may have some arch specific things so you _must_ do the
asm include.
If you look at x86 you will see that the x86 specific version
of said file specify the value of __BITS_PER_LONG.
and that value is again dependent on your target (32 or 64 bit).

	Sam
