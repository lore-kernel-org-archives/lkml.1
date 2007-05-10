Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbXEJFLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbXEJFLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXEJFKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:10:50 -0400
Received: from koto.vergenet.net ([210.128.90.7]:43303 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbXEJFKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:10:46 -0400
Date: Thu, 10 May 2007 14:10:42 +0900
From: Simon Horman <horms@verge.net.au>
To: Timur Tabi <timur@freescale.com>
Cc: Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Kumar Gala <galak@kernel.crashing.org>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Kconfig warnings on latest GIT
Message-ID: <20070510051042.GA16812@verge.net.au>
References: <200705080004.14570.ismail@pardus.org.tr> <20070508143127.38fafa3c.kim.phillips@freescale.com> <4640D988.1040504@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4640D988.1040504@freescale.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:11:52PM -0500, Timur Tabi wrote:
> Kim Phillips wrote:
> >On Tue, 8 May 2007 00:04:14 +0300
> >Ismail Dönmez <ismail@pardus.org.tr> wrote:
> >>drivers/net/Kconfig:2279:warning: 'select' used by config symbol 'UCC_GETH' 
> >>refers to undefined symbol 'UCC_FAST'
> >looks like this introduces the error:
> >commit 7d776cb596994219584257eb5956b87628e5deaf
> >Author: Timur Tabi <timur@freescale.com>
> >Date:   Mon Mar 12 15:40:27 2007 -0500
> >    [POWERPC] QE: automatically select QE options
> 
> I have a dilemma, so I need help fixing this bug.
> 
> This particular patch is necessary because without it, selecting support for 
> the QE is too complicated.
> 
> Background: The QUICC Engine (QE) is a microcontroller on some Freescale CPUs 
> that can mimic a wide variety of devices.  It has multiple controllers (called 
> UCCs), and each one can be an ethernet device, or a UART, or an HDLC thingy, 
> etc.  There's a QE library and a bunch of other support code in the 
> arch/powerpc directory, so the QE is a powerpc-specific device.  However, all 
> of the drivers that use it are located in drivers/xxx.
> 
> This isn't a new problem.  The common solution is to define some intermediate 
> Kconfig option, like UCC_FAST_TEMP in the driver's Kconfig.  Selecting UCC_FAST 
> will then also set UCC_FAST_TEMP.  The device driver then depends on 
> UCC_FAST_TEMP.
> 
> There's also a UCC_SLOW option with the same problem.
> 
> The dillema is that there is no single device driver class that depends on 
> UCC_FAST. Currently, there's only one that uses UCC_FAST: the ucc_geth driver.  
> But I'm also working on a UART driver.
> 
> So my question is: in which Kconfig do I define "UCC_FAST_TEMP" and 
> "UCC_SLOW_TEMP"?  At first I thought, just put it in drivers/Kconfig, but that 
> Kconfig does nothing but including other Kconfigs.  I believe that if I submit 
> a patch that adds "UCC_FAST_TEMP" and "UCC_SLOW_TEMP" to drivers/Kconfig, it 
> will be rejected.  Either that, or I'll spend six weeks trying to persuade 
> everyone that it's a good idea.
> 
> Does anyone have any suggestions on how I can fix this?

That does seem like a reasonable suggestion, and one that
would probably work well with the other similar problems
that have been introduced sice 2.6.21.

drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refer to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:102:warning: 'select' used by config symbol 'MOUSE_ATARI' refer to undefined symbol 'ATARI_KBD_CORE'

Which seem to be introduced by:

commit c04cb856e20a8bf68762d60737b84328c1ab5900
Author: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Date:   Tue May 1 22:32:38 2007 +0200

    m68k: Atari keyboard and mouse support.
    
    Atari keyboard and mouse support.
    (reformating and Kconfig fixes by Roman Zippel)
    
    Signed-off-by: Michael Schmitz <schmitz@debian.org>
    Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
    Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

drivers/macintosh/Kconfig:112:warning: 'select' used by config symbol 'PMAC_APM_EMU' refer to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'

Which seems to have been introduced by:

commit b302887854d6f0c6f9fc3f1080535e7c1bd53134
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Mar 20 05:18:02 2007 +1100

    [POWERPC] apm_emu: Use generic apm-emulation
    
    This patch removes a huge amount of code that is now in common code
    in drivers/char/apm-emulation.c
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

