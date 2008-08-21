Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYHUCj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYHUCj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYHUCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:39:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:55363 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYHUCjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=vl5emEBmpv02XojzXcggc8cFcZENp2cB4RiJ7mP8oann+zxz9c5TVSxUX7B+V3QOH7
         GIcYWevTp/KaB9h5hjqLYSq+3bgeUOI4RzTfrt18N0I6RPbsQbD5Czn9Ceq8GoQAeARo
         N5iDVHVR/IFysAnVqAQoGXX6IDFdiKt5dvIPI=
Message-ID: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
Date: Wed, 20 Aug 2008 22:39:15 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: ALSA pisses me off
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the ALSA asoundrc documentation (not available as a man page, grrr...)
tells me:

: Warning
:
: Neither .asoundrc or /etc/asound.conf is normally required. You should
: be able to play and record sound without either (assuming your mic and
: speakers are hooked up properly). If your system won't work without one,
: and you are running the most current version of ALSA, you probably
: should file a bug report.

Well, OK, here you go.

All I want to do is play some damn audio. All I have is a pair of
USB speakers. This should be trivial; OSS sound worked perfectly.

It hasn't been reliable since the "upgrade" to ALSA. It seems I can
go edit a complicated config file (alsa.conf, w/o man page) if I
want to make sound work. Of course, this gets overwritten with any
OS upgrade and, as noted above and obviously expected, sound should
"just work" without any config file hacking.

I gather that somebody decided that USB audio should never be selected
as the default. There are two obvious problems with this. The first is
that there exist systems that ONLY have USB audio. The second is that,
if a user adds USB audio, they probably want to use it! Plugging in a
USB audio device should take over the audio, much like plugging in a
set of headphones normally will. The use case may be very similar, such
as when using USB headphones, or the motherboard audio may be defective.

Audio is probably the #1 most frustrating and needlessly broken thing
on Linux. I haven't had it JUST WORK since we got all fancy.

Here, I'll show info and then attempt to play something appropriate.

# cat /proc/asound/cards
 0 [VirMIDI        ]: VirMIDI - VirMIDI
                      Virtual MIDI Card 1
 1 [Speakers       ]: USB-Audio - Speakers
                      Apple Computer, Inc. Speakers at
usb-0001:10:18.0-2.2, full speed
root 0 /tmp# aplay -L
default:CARD=VirMIDI
    VirMIDI
    Default Audio Device
null
    Discard all samples (playback) or generate zero samples (capture)
# ogg123 Wilhelm.ogg

Audio Device:   Advanced Linux Sound Architecture (ALSA) output

Playing: Wilhelm.ogg
Ogg Vorbis stream: 2 channel, 44100 Hz
ALSA snd_pcm_open error: No such device
Error: Cannot open device alsa.

#
