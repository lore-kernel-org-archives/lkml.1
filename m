Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXCZEdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXCZEdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 00:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbXCZEdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 00:33:23 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:56104 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933571AbXCZEdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 00:33:22 -0400
Message-ID: <46074CD2.8000002@boichat.ch>
Date: Mon, 26 Mar 2007 12:32:18 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Nicolas Boichat <nicolas@boichat.ch>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@lists.sourceforge.net,
       tiwai@suse.de
Subject: Re: [BUG] Patch "CPU hotplug: call check_tsc_sync_source() with irqs
 off" breaks some drivers
References: <4606CA92.1000405@boichat.ch>
In-Reply-To: <4606CA92.1000405@boichat.ch>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.187.18 (nusnet-187-18.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Boichat wrote:
> Hello,
> 
> I'm running a Macbook Pro first generation (Core Duo, so x86).
> 
> I ran accross these two problems while upgrading from 2.6.21-rc3 to the
> current git HEAD:
>  1. appletouch cannot initialize the device properly at boot time (the
> module is automatically loaded by Gentoo), I have to reload the module
> to get it to work.
>  2. ALSA hda_intel (patch_sigmatel) fails to read properly the subsystem
> id. "head  /proc/asound/card0/codec#0" returns:
>> Codec: SigmaTel STAC9221 A1
>> Address: 0
>> Vendor Id: 0x83847680
>> Subsystem Id: 0x100
>> Revision Id: 0x103401
> while I expect this subsystem id: 0x106b0200.
> This is due to a read failure in sound/pci/hda/hda_codec.c at line 553
> (I have to reboot on OS X to get the id correct again, and it seems to
> happen quite randomly, so I'm not absolutely certain this bug is
> related, but it's something i have never seen before...)
> 
> I found out which commit seems to cause these bugs:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d04f41e35343f1d788551fd3f753f51794f4afcf
> 
> The latest GIT without this commit works fine, but doesn't with it.

Sorry about blaming this commit. The problems happen randomly (about 1
reboot over 2 is ok, at least with 2.6.21-rc4). I'll run more tests and
post the results later.

Best regards,

Nicolas

