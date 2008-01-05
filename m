Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYAER0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYAER0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYAER0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:26:46 -0500
Received: from aaocbn.aao.GOV.AU ([192.231.166.223]:46947 "EHLO
	aaocbn.aao.gov.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYAER0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:26:45 -0500
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 12:26:44 EST
To: linux-kernel@vger.kernel.org
From: TimC <tconnors@no.spam.accepted.here-astro.swin.edu.au>
Subject: snd_hda_intel kills beeper speaker on dell laptop
Mail-Copies-To: tconnors@astro.swin.edu.au
X-Editor: xemacsclientserver
X-EndlessSeptember: Sun Sep 5241 04:07:43 EST 1993
X-yes-we-have-no-x-yes-archive-today: NO
X-Face: m+g#A-,3D0}Ygy5KUD`Hckr=I9Au;w${NzE;Iz!6bOPqeX^]}KGt=l~r!8X|W~qv'`Ph4dZczj*obWD25|2+/a5.$#s23k"0$ekRhi,{cP,CUk=}qJ/I1acc
Message-ID: <slrn-0.9.7.4-14678-25767-200801060407-tc@hexane.ssi.swin.edu.au>
Organization: not organised at all
User-Agent: slrn/0.9.8.1pl1 (Debian)
Date: Sun, 6 Jan 2008 04:14:43 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, everyone else tries to get rid of their beeper speaker, but I
must be old school or something.

My Inspiron 1520 has:
Audio devices:
0: STAC92xx Analog (DUPLEX)
Mixers:
0: SigmaTel STAC9205
and uses the snd_hda_intel driver, but as soon as it is
inserted, I lose the beeper speaker.  Yes, pcspkr is modprobed into
the kernel.  I am currently using 
"options snd-hda-intel model=dell-m44 probe_mask=1"
but I've tried this with various options (ref, etc).  I have tried
various kernels between 2.6.18 (debian backported) and 2.6.23.  There
is no mixer control that looks like a pc beeper speaker control, like
on my old Inspiron 4000, using the maestro3 alsa driver.  Similarly,
no switches bring the pc speaker back.

Before snd_hda_intel is inserted, the pc speaker is very loud and
obviously can't be turned down because there is no mixer at this
stage.  It obviously comes out of the same speakers as the sound
driver controls.  Similarly, when resuming from a suspend, _without
having rmmodded the sound drivers_, the pc speaker exists in its very
loud state.  But as soon as I do something involving the sound card or
mixer -- play a sound, reduce the volume, etc, the pc speaker
immediately goes away.  Obviously snd_hda_intel is turning off
some mixer hardware somewhere.

Does these lines from /proc/asound/card0/codec#0 tell me that the pc
beeper speaker is not muted, or is this something entirely different?

Node 0x23 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=0
  Amp-Out vals:  [0x00]

Anything I am obviously missing?

-- 
TimC
Special Relativity: The person in the other queue thinks yours is
moving faster.
