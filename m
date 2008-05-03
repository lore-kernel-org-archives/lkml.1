Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYECVE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYECVE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYECVER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:04:17 -0400
Received: from t03.superonline.com ([212.252.122.150]:46595 "EHLO
	t03.superonline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYECVEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:04:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 May 2008 17:04:16 EDT
Message-ID: <481CD1B9.3020601@superonline.com>
Date: Sat, 03 May 2008 23:57:29 +0300
From: Vefa Bicakci <bicave@superonline.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tiwai@suse.de
Subject: [Bisected Regression] snd-intel-hda no longer produces sound on Toshiba
 Satellite A100
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using Debian Sid on a Toshiba Satellite A100 series laptop.
This laptop has an Intel HDA sound card. It uses the Realtec codecs.
After modprobe'ing snd-intel-hda, the following appears in dmesg:
"hda_codec: Unknown model for ALC861, trying auto-probe from BIOS..."

The sound output used to work fine with 2.6.24.x and 2.6.25. In an
unrelated move, I decided to give 2.6.25-gitX series a try; however,
I was very sad to notice that sound output became disabled. Programs
such as ogg123 or Amarok seem to play, but there is no sound output,
only silence. I have checked multiple times that no new mixer settings
appeared because of a possible snd-hda-intel update...

I bisected the differences between 2.6.25 and HEAD (as of 28th of
April) to find the problematic git commit. The git commit with the
following ID and description disables the sound output completely:

--- 8< ---
commit f6c7e5461e9046445d50c5c7a9a4587824239623
[ALSA] hda-codec - Fix auto-configuration of Realtek codecs
--- >8 ---

I believe that this is an important regression, and I would like
to debug this problem. Trying out patches is no problem for me.

Since the mentioned commit was made by Takashi Iwai, I am CC'ing him
too.

Regards,

Vefa Bicakci

Note: For the record, here is the "git bisect log" output:

--- 8< ---
git-bisect start
# good: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
git-bisect good 4b119e21d0c66c22e8ca03df05d9de623d0eb50f
# bad: [064922a805ec7aadfafdd27aa6b4908d737c3c1d] Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git-bisect bad 064922a805ec7aadfafdd27aa6b4908d737c3c1d
# good: [4a1fd556c1f1fbd6d9d6739efec042324732b697] [ARM] fix 48d7927bdf071d05cf5d15b816cf06b0937cb84f
git-bisect good 4a1fd556c1f1fbd6d9d6739efec042324732b697
# good: [b0166ab3a6ae6d7af8d9a21a7836154963c69a11] V4L/DVB (7731): tuner-xc2028: fix signal strength calculus
git-bisect good b0166ab3a6ae6d7af8d9a21a7836154963c69a11
# bad: [4b7227ca321ccf447cdc04538687c895db8b77f5] Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-xen-next
git-bisect bad 4b7227ca321ccf447cdc04538687c895db8b77f5
# bad: [346ad4b7fe392571f19314f153db9151dbc1d82b] Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6
git-bisect bad 346ad4b7fe392571f19314f153db9151dbc1d82b
# bad: [87b57fe2d3fb1ce33671b944db9a4cbe0cd065ea] [ALSA] wm9713: Don't control touch screen power on suspend
git-bisect bad 87b57fe2d3fb1ce33671b944db9a4cbe0cd065ea
# bad: [fd2499f0ed765de3ab11c7fd6f37f9fbfaf059ec] [ALSA] aw2 - Remove endian dependency
git-bisect bad fd2499f0ed765de3ab11c7fd6f37f9fbfaf059ec
# bad: [34b6757dc7ce0e9d5d3930b29d53a7bcb0fde047] [ALSA] aw2 - Add missing module parameters
git-bisect bad 34b6757dc7ce0e9d5d3930b29d53a7bcb0fde047
# good: [e1406348129dc2db60ccad079c3d014200590557] [ALSA] hda-codec - Clean up capture source selection of Realtek codecs
git-bisect good e1406348129dc2db60ccad079c3d014200590557
# bad: [310355c111dbae005269fe3fc39afdd60779bf5d] [ALSA] Davinci ASoC support
git-bisect bad 310355c111dbae005269fe3fc39afdd60779bf5d
# bad: [d260cdf65657382c4cde366a1c7d4ddce669a427] [ALSA] hda-codec - Fix breakage of resume in auto-config of realtek codecs
git-bisect bad d260cdf65657382c4cde366a1c7d4ddce669a427
# bad: [f6c7e5461e9046445d50c5c7a9a4587824239623] [ALSA] hda-codec - Fix auto-configuration of Realtek codecs
git-bisect bad f6c7e5461e9046445d50c5c7a9a4587824239623
# good: [5832fcf8b55cfdbd7d8511f747d15fd20ed4703d] [ALSA] hda-codec - More fix-up for auto-configuration
git-bisect good 5832fcf8b55cfdbd7d8511f747d15fd20ed4703d
--- >8 ---


