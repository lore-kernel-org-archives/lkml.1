Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXJKLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXJKLbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXJKLbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:31:15 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38127
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751236AbXJKLbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:31:14 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Date: Thu, 11 Oct 2007 06:31:09 -0500
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710110923470.23818@anakin>
In-Reply-To: <Pine.LNX.4.64.0710110923470.23818@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710110631.09231.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 2:25:19 am Geert Uytterhoeven wrote:
> On Wed, 10 Oct 2007, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Rip out hardwired cross compiler name assumption that only m68k makes.
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
> > ---
> > When you cross compile, you have to set the prefix CROSS_COMPILE to your
> > cross compiler prefix.  You need to do this for all targets (arm, mips,
> > ppc, x86-64 on x86, etc).  This is not specific to m68k, and this value
> > is supplied _to_ the build, not supplied _by_ the build.
> >
> > The build shouldn't unconditionally overwrite the existing value of this
> > variable with one it makes up.  It has no idea what I called my cross
> > compiler.
>
> The build does not unconditionally overwrite the existing value of this
> variable. You can specify the name of your cross compiler like this:
>
>     make CROSS_COMPILE=m68k-linux-

I noticed this because you have to specify ARCH for "make headers_install" but 
don't have to specify a CROSS_COMPILE prefix for that because it doesn't 
build anything.  Yet the first line it spits out is a complaint that it can't 
find m68k-linux-gnu-gcc.

I do note that the error message doesn't stop the build, and seems to be 
ignored...

> BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.

*shrug*  This is the eleventh target I've tried to build, and the first one 
that has this behavior.  It seemed unnecessary at best.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
