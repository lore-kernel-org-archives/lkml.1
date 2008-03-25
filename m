Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbYCYUPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbYCYUPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbYCYUP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:15:29 -0400
Received: from outbound-mail-134.bluehost.com ([67.222.39.24]:51102 "HELO
	outbound-mail-134.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759464AbYCYUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:15:27 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 16:15:27 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Tue, 25 Mar 2008 13:08:43 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
References: <47D828BB.2000702@gawab.com> <200803191648.59400.jbarnes@virtuousgeek.org> <47E86C60.5040706@gawab.com>
In-Reply-To: <47E86C60.5040706@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251308.43830.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 24, 2008 8:07 pm Justin Madru wrote:
> Jesse Barnes wrote:
> > Good luck with the upgrade...
>
> Well, the upgrade went ok, and compiling the reg_dumper using the
> libpciaccess .deb from Bryce worked. Then I tried to add to the boot
> scripts a call to reg_dumper...
> ...To make a long story short...
> I somehow killed my boot scripts! Anyways, I did a fresh reinstall of
> Ubuntu 8.4 Beta.
>
> I'm still getting the blank screen problem with the 2.6.25-rc6 kernel,
> so I guess it wasn't a Ubuntu software problem (or I hope not, because that
> could be really hard to find).
>
> What I did was created a script that took a reg_dump every 6 secs for 1
> min. I made that as rc2.d/S01regdump so it should've been the very first
> thing called. So, I hope there's enough "data points" to see what's
> happening.
>
> Reg Dump Information
> 	http://jdserver.homelinux.org/linux/reg_dump.tar.bz2

Wow, that's a lot of dump files. :)

I was worried that in the "blank" case we may see the same register dump
as in the working case, but thankfully they're different.  In fact, in all
the dumps after 0 in the 2.6.25-blank case, both pipes are disabled and
the LCD itself is disabled.

The important bits:

@@ -24,7 +24,7 @@
 (II):          DVOB_SRCDIM: 0x00000000
 (II):          DVOC_SRCDIM: 0x00000000
 (II):           PP_CONTROL: 0x00000001 (power target: on)
-(II):            PP_STATUS: 0xc0000008 (on, ready, sequencing idle)
+(II):            PP_STATUS: 0x0000000a (off, not ready, sequencing idle)
 (II):         PFIT_CONTROL: 0x80002668
 (II):      PFIT_PGM_RATIOS: 0x00000000
 (II):      PORT_HOTPLUG_EN: 0x00000020
@@ -36,7 +36,7 @@
 (II):             DSPABASE: 0x00000000
 (II):             DSPASURF: 0x00000000
 (II):          DSPATILEOFF: 0x00000000
-(II):            PIPEACONF: 0x00000000 (disabled, single-wide)
+(II):            PIPEACONF: 0x000c0000 (disabled, single-wide)
 (II):             PIPEASRC: 0x027f01df (640, 480)
 (II):            PIPEASTAT: 0x80000203 (status: FIFO_UNDERRUN VSYNC_INT_STATUS VBLANK_INT_STATUS OREG_UPDATE_STATUS)
 (II):         FBC_CFB_BASE: 0x00000000
@@ -59,16 +59,16 @@
 (II):              VSYNC_A: 0x01eb01e9 (490 start, 492 end)
 (II):            BCLRPAT_A: 0x00000000
 (II):         VSYNCSHIFT_A: 0x00000000
-(II):             DSPBCNTR: 0x95000000 (enabled, pipe B)
+(II):             DSPBCNTR: 0x15000000 (disabled, pipe B)
 (II):           DSPBSTRIDE: 0x00000500 (1280 bytes)
 (II):              DSPBPOS: 0x00000000 (0, 0)
 (II):             DSPBSIZE: 0x01df027f (640, 480)
 (II):             DSPBBASE: 0x00000000
 (II):             DSPBSURF: 0x00000000
 (II):          DSPBTILEOFF: 0x00000000
-(II):            PIPEBCONF: 0x80000000 (enabled, single-wide)
+(II):            PIPEBCONF: 0x000c0000 (disabled, single-wide)
 (II):             PIPEBSRC: 0x027f01df (640, 480)
-(II):            PIPEBSTAT: 0x00000202 (status: VSYNC_INT_STATUS VBLANK_INT_STATUS)
+(II):            PIPEBSTAT: 0x00000242 (status: VSYNC_INT_STATUS LBLC_EVENT_STATUS VBLANK_INT_STATUS)
 (II):                 FPB0: 0x00031107 (n = 3, m1 = 17, m2 = 7)
 (II):                 FPB1: 0x00031108 (n = 3, m1 = 17, m2 = 8)
 (II):               DPLL_B: 0x98026003 (enabled, non-dvo, spread spectrum clock, LVDS mode, p1 = 2, p2 = 14, SDVO mult 1)

So somehow both pipes are getting disabled, and your LCD is getting turned
off and things never get re-enabled.  The X driver should have turned things
back on though, after detecting what's available.  Do you have your X logs
from the working & broken cases?  Also, did you try reproducing the blank
screen problem w/o gdm enabled as Bryce suggested?  That could help narrow
down if it's just an intelfb problem vs. a new intelfb/X driver interaction
bug.

I still don't know why this behavior would have changed between 2.6.24 and
2.6.25-rc though... maybe the fb guys have some clue about other fb changes
that may have affected things.

Thanks a lot for your hard work so far in debugging this...

Thanks,
Jesse
