Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYC3UYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYC3UYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYC3UYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:24:17 -0400
Received: from gherkin.frus.com ([192.158.254.49]:49517 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYC3UYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:24:16 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47EE317E.9030807@keyaccess.nl> "from Rene Herman at Mar 29, 2008
 01:09:34 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Sun, 30 Mar 2008 15:24:04 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Tyson Whitehead <twhitehe@uwo.ca>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080330202404.AB288DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Okay. The thing that "fixed" Tyson was disabling mmap from the driver:
> 
> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-March/006911.html

I'll be trying that just a little later today, as in, sometime in the
next half hour or so.

> It landed him in the same situation as you though, where that "asskickd.wav" 
> mono, 8-bit 11025 file you sent me shows the same behaviour you reported. 
> This might imply you weren't using mmap to begin with. You have no horribly 
> obsolete alsa userland, nor an /etc/asound.conf or ~/.asoundrc?

I don't have either of the two files mentioned above.  As far as the alsa
userland, I would think it's all "reasonably" current.  I'm running Debian
"Etch" fully patched/updated.  I'll normally refrain from running things
in the "unstable" or "experimental" categories unless something is broken
in the "stable" tree that isn't getting fixed (e.g., a libc problem).
Beyond that, I also tend to run the latest kernels to make sure we (the
community) get an early warning if there are problems with kernel
updates/changes on the Alpha architecture.  Because it's a reasonably
small list, here is the relevant "dpkg -l" output for alsa packages:

Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Installed/Config-files/Unpacked/Failed-config/Half-installed
|/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err: uppercase=bad)
||/ Name                               Version                              Description
+++-==================================-====================================-================================================================
ii  alsa-base                          1.0.13-5etch1                        ALSA driver configuration files
ii  alsa-oss                           1.0.12-1                             ALSA wrapper for OSS applications
ii  alsa-utils                         1.0.13-2                             ALSA utilities
ii  alsaplayer-alsa                    0.99.76-9                            PCM player designed for ALSA (ALSA output module)
ii  alsaplayer-common                  0.99.76-9                            PCM player designed for ALSA (common files)
ii  alsaplayer-esd                     0.99.76-9                            PCM player designed for ALSA (EsounD output module)
ii  alsaplayer-gtk                     0.99.76-9                            PCM player designed for ALSA (GTK version)
ii  gstreamer0.10-alsa                 0.10.10-4                            GStreamer plugin for ALSA
ii  libasound2                         1.0.13-2                             ALSA library
ii  linux-sound-base                   1.0.13-5etch1                        base package for ALSA and OSS sound systems

> No change with "aplay -M"?
> (and)
> This one needs answer so as to possibly pin things down to format:
> 
> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-March/006914.html

Reported on the results of the various "sox" tests in that article last
night.

For all of the above, I need to mention I am/was running an unpatched
2.6.25-rc7 kernel.  "cat /proc/interrupts" shows absolutely no interrupt
activity for the ES1888.  Here's the current and complete output for an
uptime of 1 day, 14:14:

  1:      10718          XT-PIC   i8042
  2:          0          XT-PIC   cascade
  4:          1          XT-PIC   serial
  5:          0          XT-PIC  +ES18xx
  8:  140919958             RTC  +timer
 12:      13965          XT-PIC   i8042
 14:    1231903          XT-PIC   ide0
 18:          0           PYXIS   halt-switch
 22:          0           PYXIS   timer-cascade
 23:          0           PYXIS   isa-cascade
 24:     116344           PYXIS   eth0
 32:   14938196           PYXIS   radeon@pci:0000:00:0c.0
 40:     417084           PYXIS   qla1280
ERR:          0

Ok.  Let me boot on the kernel with the "miata_no_mmap" patch and give
that a spin.  I'll report back shortly.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
