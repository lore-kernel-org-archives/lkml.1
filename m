Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbYCHD6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbYCHD6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 22:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYCHD6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 22:58:31 -0500
Received: from gherkin.frus.com ([192.158.254.49]:36083 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYCHD6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 22:58:30 -0500
Subject: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
To: linux-kernel@vger.kernel.org
Date: Fri, 7 Mar 2008 21:58:28 -0600 (CST)
CC: linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080308035828.E9403DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I feel bad about bringing this one up because I honestly have no idea
*when* the driver quit working.  (I don't always have a spare set of
speakers available for the Alpha).  This literally could have been
broken for months...

Symptoms:

(1) Using the sox-based "play" command to play a short ".wav" file
    results in the file being played approx. 1.5 times, i.e., it plays
    all the way through, then restarts from the beginning and quits
    somewhere in the middle of the second playback.  At least the
    sound doesn't seem distorted...

(2) Using "mpg123" results in silence at first, then after about 30
    seconds, a tight loop of random repeating sound (doesn't sound like
    part of the mp3 file, but it's probably derived from it :-)) until
    the process is forcibly killed.

I have to hit <ctrl>C twice to interrupt playback.

/proc/asound/cards looks normal:

 0 [ES1888         ]: ES1888 - ESS AudioDrive ES1888
                      ESS AudioDrive ES1888 at 0x220, irq 5, dma1 1, dma2 5

Here are the ALSA module options I've always had defined in
/etc/modprobe.d/sound:

alias snd-card-0 snd-es18xx
alias sound-slot-0 snd-es18xx
options snd-es18xx enable=1 isapnp=0 port=0x220 irq=5 dma1=1 dma2=5 mpu_port=0x330

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
