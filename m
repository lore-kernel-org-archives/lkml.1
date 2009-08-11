Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZHKQ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZHKQ1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZHKQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:27:34 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:34747 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZHKQ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:27:33 -0400
Date: Tue, 11 Aug 2009 18:27:30 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Alain Knaff <alain@knaff.lu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
Message-ID: <20090811162730.GM9704@pc-ras4041.res.insa>
References: <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop> <4A7C14EB.1060701@parrot.com> <20090807130130.GE4455@laptop> <4A7C2BA4.7030408@parrot.com> <20090807135524.GF4455@laptop> <20090807200001.GE31543@n2100.arm.linux.org.uk> <20090807210816.GA29797@merkur.ravnborg.org> <20090811094418.GI9704@pc-ras4041.res.insa> <4A819642.10700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A819642.10700@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 09:03:14AM -0700, H. Peter Anvin wrote :
> On 08/11/2009 02:44 AM, Albin Tonnerre wrote:
> > Hi Sam,
> > 
> > On Fri, Aug 07, 2009 at 11:08:16PM +0200, Sam Ravnborg wrote :
> >> We could add libgcc as a prerequisite.
> >> Untested patch below.
> > 
> > When compiling with this patch applied, I get the following error:
> > 
> >   Kernel: arch/arm/boot/Image is ready
> >     LD      arch/arm/boot/compressed/vmlinux
> > /home/albin/x-tools/arm-unknown-linux-uclibcgnueabi/lib/gcc/arm-unknown-linux-uclibcgnueabi/4.3.2/libgcc.a(_dvmd_lnx.o):
> > In function `__div0':
> > /home/albin/devel/free-electrons/toolchain/targets/src/gcc-4.3.2/libgcc/../gcc/config/arm/lib1funcs.asm:1079:
> > undefined reference to `raise'
> > make[2]: *** [arch/arm/boot/compressed/vmlinux] Error 1
> > make[1]: *** [arch/arm/boot/compressed/vmlinux] Error 2
> > 
> > I've got no idea where this symbol is defined, though. Has anyone an idea on
> > this ?
> > 
> 
> raise() gets called by libgcc to handle division by zero.

So I guess the only options left are either define a dummy raise() function, or
get rid of the divisions like Alain Knaff did in his patch ?

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
