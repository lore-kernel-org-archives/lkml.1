Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbYFHB4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbYFHB4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 21:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbYFHB4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 21:56:35 -0400
Received: from web53709.mail.re2.yahoo.com ([206.190.37.30]:35294 "HELO
	web53709.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756699AbYFHB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 21:56:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1c09p3TSw4GwDjsrZgM4c3JmkPd4Zx++uaTv1S2KydFRDFeei4s9/Nyx/HkGLbsVUwR5v33czvRXJP++62XSXdSjaExfemOiCT8EFFSS6UBQ7k3mU4W/aZgIyDXKCmBEYCrEGLfXEGfeUraXg51+1tNjQKErAgpAZc5ooRit0K0=;
X-YMail-OSG: Fgl5l9gVM1kPjk8CV6mzbWuAdde2Z6F2LI3f2c7wUOqqvpTm_S6P1PafXyPLeuGJ5A--
Date: Sat, 7 Jun 2008 18:56:33 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: Linux-next Alsa hda_intel events/0 high CPU usage, bisected
To: linux-kernel@vger.kernel.org
In-Reply-To: <s5hk5h1shys.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <424883.96640.qm@web53709.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Takashi Iwai <> wrote:

> The problem is that your hardware reports the wrong DMA position.
> I didn't expect that this delay is so much, (IOW, the hardware is so
> buggy).  Maybe it should be put into its own workq.

I've been getting my process timing information from ps, top, and htop, which
I know can be unreliable in some ways (I've been using a tickless (NO_HZ=y)
kernel). I recompiled the g8a4bd4d kernel with that option off and a few more
changes to make my settings more conservative, and rechecked events/0. It
still reports at a consistent 2.5%, (down from about 4.3% with previous kernel
options) and after a short period of use (uptime 30 minutes) events/0 has had
0:48 of time. In comparison, Xorg and Firefox (usually the biggest users)
report 1:12 and 0:44 in the same timeframe. 

So if I understand the purpose of the code, that means that my system has
generated 48 seconds worth of timing mistakes in audio playback relative to 25
minutes or so of audio stream, so that suggests the timing error of the
hardware is about 3%! That seems like huge latency for hardware so I see why
you wouldn't expect that.

I should also say that close listening has convinced me that my audio
performance has been IMPROVED by the patch - IOW, the code is working well at
improving the audio stream, even though its using a fair amount of CPU time to
do it. With the new code, I seem to hear less random clicks, interruptions, or
static that I had previously blamed on the source of the audio. I don't know
how to test the output to the speakers relative to the input source
quantitatively, though.

Given that the worst-case-scenario for compensating for buggy hardware is
worse than expected, what is the best behavior for the driver given hardware
like mine? I don't know if a high CPU time for the events/0 process is
actually a problem, I'm just not used to seeing a -5 niceness process so
active under top. Let me know if you'd like any more info on my hardware or
setup, or if there are any additional kernel config options that might affect
my DMA reporting errors. I'm trying to be a useful linux-next tester, so any
advice is appreciated.
Ben


      
