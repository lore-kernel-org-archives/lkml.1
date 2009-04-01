Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZDAFTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZDAFTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZDAFTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:19:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:41382 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZDAFTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YLeARyUwgR9X23qP5BtIEn2GOSO8iwlAsLfLXn2q16XmmqvLaI6b6fItHSBvsGnbce
         wsNbQFynJxN4canklX3WOjwy4hoKKTHPwXAuhwZ2dfN+7iTWthORkZmNOqiJdjs2hmsV
         eFVZlEKLuVhd7pJfABUnuVzyjzIcKeoSNCAWs=
MIME-Version: 1.0
In-Reply-To: <9b1675090903302211q5703af7fo33f45c93e5db34f0@mail.gmail.com>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
	 <200903301357.17076.alistair@devzero.co.uk>
	 <9b1675090903300826s2ce361e5s1134e13507b0399@mail.gmail.com>
	 <200903301944.30030.alistair@devzero.co.uk>
	 <9b1675090903302211q5703af7fo33f45c93e5db34f0@mail.gmail.com>
Date: Tue, 31 Mar 2009 23:19:33 -0600
Message-ID: <9b1675090903312219q5f6df0cbwef86cbdafe035667@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, git doesn't know what to do in my circumstances.  I'm thinking
that multiple changes have combined to cause the problem, because the
one that git claims is the last bad commit, can't be.  In
30d72e9f614e7bd76e28d4d92bd54d90a96905bb, the last one to be marked
good, I had to move the power_save inside of an "ifdef", in order for
it to compile, which is the exact same fix that
11cd41b893895c76a8f9bee9467f4b0869b5eeb3 provides.  So, it's got to be
a combo problem of some sort.

Here's the log.
git bisect start
# bad: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
git bisect bad 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git bisect good 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
# bad: [2774de17ba65130165a2cbca92e5a685581f7916] Staging: benet:
build is broken unless CONFIG_NETPOLL is enabled
git bisect bad 2774de17ba65130165a2cbca92e5a685581f7916
# bad: [ba744d5e290055d171c68067259fcc1e2721f542] block: reorder
struct bio to remove padding on 64bit
git bisect bad ba744d5e290055d171c68067259fcc1e2721f542
# bad: [54a696bd07c14d3b1192d03ce7269bc59b45209a] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git bisect bad 54a696bd07c14d3b1192d03ce7269bc59b45209a
# bad: [bb26c6c29b7cc9f39e491b074b09f3c284738d36] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
git bisect bad bb26c6c29b7cc9f39e491b074b09f3c284738d36
# bad: [a65056205cdf7efb96fb2558e4f1ec6bae2582ed] Merge branch
'topic/hda' into to-push
git bisect bad a65056205cdf7efb96fb2558e4f1ec6bae2582ed
# good: [86b3aa390b4b9925f16a21b98441fd7abdb9fff2] Merge branch
'topic/ca0106' into to-push
git bisect good 86b3aa390b4b9925f16a21b98441fd7abdb9fff2
# good: [b83923a3931a43df7397a7491f0c9d9b9d46624a] ALSA: hda - minor
HDMI code cleanups
git bisect good b83923a3931a43df7397a7491f0c9d9b9d46624a
# bad: [0ff555192a8d20385d49d1c420e2e8d409b3c0da] Merge branch
'fix/hda' into topic/hda
git bisect bad 0ff555192a8d20385d49d1c420e2e8d409b3c0da
# skip: [1289e9e8b42f973f2ab39e5f4f2239ff826c27e9] ALSA: hda -
Modularize HD-audio driver
git bisect skip 1289e9e8b42f973f2ab39e5f4f2239ff826c27e9
# bad: [11cd41b893895c76a8f9bee9467f4b0869b5eeb3] ALSA: hda - Fix
build error with CONFIG_SND_HDA_POWER_SAVE
git bisect bad 11cd41b893895c76a8f9bee9467f4b0869b5eeb3
# good: [0e19e7d2bff0ec04fe4dc920c580d8a321afa07f] Merge branch
'topic/fix/hda' into topic/hda
git bisect good 0e19e7d2bff0ec04fe4dc920c580d8a321afa07f
# good: [4f199629b0fba95fd5caecbf35ed68417d9a9b7a] ALSA:
sound/pci/hda/hda_codec.c: cleanup kernel-doc
git bisect good 4f199629b0fba95fd5caecbf35ed68417d9a9b7a
# good: [529bd6c4a63f8468fd66f63fdc22d7070439b3cd] ALSA: hda - Fix PCM
reconfigure
git bisect good 529bd6c4a63f8468fd66f63fdc22d7070439b3cd
# good: [30d72e9f614e7bd76e28d4d92bd54d90a96905bb] ALSA: hda - Fix
creation of automatic capture mixers
git bisect good 30d72e9f614e7bd76e28d4d92bd54d90a96905bb

So, the problem appears to exist in the changes between these two commits...
git diff 0e19e7d2bff0ec04fe4dc920c580d8a321afa07f
11cd41b893895c76a8f9bee9467f4b0869b5eeb3 | less

I may play around a little more at a later date, but I'm busy for the
next few days.
