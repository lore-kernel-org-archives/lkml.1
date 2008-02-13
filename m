Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbYBMPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbYBMPAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYBMPA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:00:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:10634 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbYBMPA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:00:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j/jSC2MFU3j82SF74j9ALq6b3jdyVcSiA0FCON7WDzufWSB6iN0B1p179o4egXC9emlZsLmZVTOhHNHYMEGGtJ6uw9Ien0ecoMT66fW7uMRqqgXaADhsXBNK4eFsY9O59OEwy4nAB6p6oHBEZYGeyyOT2a5h4yN+5+t4nsoPOXU=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Wed, 13 Feb 2008 16:00:21 +0100
User-Agent: KMail/1.9.7
Cc: alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <200802131305.48471.strohel@gmail.com> <s5h63wtt38z.wl%tiwai@suse.de>
In-Reply-To: <s5h63wtt38z.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802131600.21841.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 of February 2008 14:06:20 Takashi Iwai wrote:
> > This patch did not have any effect. (i haven't tested suspend-to-ram)
> >
> > alsa-info before powersaving (speaker silent, mixer says: Speaker=MM):
> > http://pastebin.ca/902330
> >
> > alsa-info after powersaving (speaker loud, mixer says: Speaker=MM):
> > http://pastebin.ca/902332
>
> Oh, it's my thinko.  The init routine shouldn't update the amp cache.
>
> The patch below should fix this problem.  Actually it reverts the code
> to my first patch.

Eh, this one wasn't successful. The symptoms are the same, and the diff 
between alsa-info before and after powersaving remained also the same:
--- alsa-info.1.txt     2008-02-13 15:56:18.000000000 +0100
+++ alsa-info.2.txt     2008-02-13 15:58:15.000000000 +0100
@@ -3,7 +3,7 @@
 !!ALSA Information Script v 0.4.36
 !!################################

-!!Script ran on: St úno 13 15:56:18 CET 2008
+!!Script ran on: St úno 13 15:58:14 CET 2008


 !!Linux Distribution
@@ -200,7 +200,7 @@
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
-  Amp-Out vals:  [0x80 0x80]
+  Amp-Out vals:  [0x00 0x00]
   Pincap 0x083e: IN OUT HP Detect Trigger
   Pin Default 0x99130120: [Fixed] Speaker at Int ATAPI
     Conn = ATAPI, Color = Unknown
@@ -356,7 +356,7 @@

 crw-rw---- 1 root audio 116,  0 2008-02-13 15:48 /dev/snd/controlC0
 crw-rw---- 1 root audio 116, 24 2008-02-13 15:48 /dev/snd/pcmC0D0c
-crw-rw---- 1 root audio 116, 16 2008-02-13 15:55 /dev/snd/pcmC0D0p
+crw-rw---- 1 root audio 116, 16 2008-02-13 15:58 /dev/snd/pcmC0D0p
 crw-rw---- 1 root audio 116, 30 2008-02-13 15:48 /dev/snd/pcmC0D6c
 crw-rw---- 1 root audio 116, 22 2008-02-13 15:48 /dev/snd/pcmC0D6p
 crw-rw---- 1 root audio 116,  1 2008-02-13 15:49 /dev/snd/seq
