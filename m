Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYGCIb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYGCIb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYGCIR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:17:28 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:19735 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937021AbYGCHmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:42:52 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 03:42:51 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4BAIsdbEjEAmHEfGdsb2JhbACSRAEBECADAZ8A
X-IronPort-AV: E=Sophos;i="4.27,714,1204495200"; 
   d="scan'208";a="5224617"
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.26-rc5-git2: snd-emu10k1 does not work
Date: Thu, 3 Jul 2008 09:31:54 +0200
User-Agent: KMail/1.9.9
Cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200806082303.59245.rjw@sisk.pl> <s5hzlp3f9o6.wl%tiwai@suse.de> <200806302236.45838.rjw@sisk.pl>
In-Reply-To: <200806302236.45838.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807030931.54808.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.26-rc5-git2: snd-emu10k1 does not work
X-Scan-Signature: 66ef1fdbada42626acd1325709678e85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 22:36:45 Rafael J. Wysocki wrote:
> I tried vanilla 2.6.25 and it behaved exactly like the current -git, so
> this is not a recent regression.
>
> Still, it's interesting why the openSUSE kernels work with the card without
> any problems while the kernel.org ones apparently don't.
>

I had the same problem with Mandriva, try the following:
la -l /dev/snd/

you should have something like this:
total 0
0 crw-rw---- 1 root audio 116,  0 2008-07-03 08:44 controlC0
0 crw-rw---- 1 root audio 116,  4 2008-07-03 08:44 hwC0D0
0 crw-rw---- 1 root audio 116,  8 2008-07-03 08:44 midiC0D0
0 crw-rw---- 1 root audio 116,  9 2008-07-03 08:44 midiC0D1
0 crw-rw---- 1 root audio 116, 24 2008-07-03 08:45 pcmC0D0c
0 crw-rw---- 1 root audio 116, 16 2008-07-03 08:45 pcmC0D0p
0 crw-rw---- 1 root audio 116, 25 2008-07-03 08:44 pcmC0D1c
0 crw-rw---- 1 root audio 116, 26 2008-07-03 08:44 pcmC0D2c
0 crw-rw---- 1 root audio 116, 18 2008-07-03 08:44 pcmC0D2p
0 crw-rw---- 1 root audio 116, 19 2008-07-03 08:44 pcmC0D3p
0 crw-rw---- 1 root audio 116, 28 2008-07-03 08:44 pcmC0D4c
0 crw-rw---- 1 root audio 116, 20 2008-07-03 08:44 pcmC0D4p
0 crw-rw---- 1 root audio 116,  1 2008-07-03 08:44 seq
0 crw-rw---- 1 root audio 116, 33 2008-07-03 08:44 timer

create the audio group and add you self to it, it required a reboot for the 
changes to apply, but if you are too lazy to reboot: chmod 666 /dev/snd/* 
will work ;)


