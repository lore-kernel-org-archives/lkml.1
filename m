Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZLNUi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZLNUi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZLNUi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:38:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZLNUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:38:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Mon, 14 Dec 2009 20:38:09 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00048-g652c393; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <1260741245.3123.0.camel@t60prh> <20091214102015.2f43f5b4@jbarnes-piketon>
In-Reply-To: <20091214102015.2f43f5b4@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912142038.09254.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2VoS/ZZml5glQIvclbUm1dmwL1F12jwpMVx/
 iTMvJqLHGW0IP9lZwHBhj4p547Qiv13MP6KZo2VCzDC6MmqctM
 JvAPd9eMFoTrliZNLBT7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009 18:20:15 Jesse Barnes wrote:
> You can disable most of that code by loading i915 with 'powersave=0'.
> If that patch really is at fault the powersave=0 should work around the
> issue as well.

Ok, I'll try that and let you know. Running the kernel before your
patch has not crashed yet after two days of uptime. Now running
with your patch but nothing else. When that crashes, I'll try
the latest mainline with powersave=0.
 
> It's been implicated in another issue (some display flicker and
> underruns) so I'm pretty sure there's something wrong with it in some
> configurations at least...

I haven't seen that yet. FWIW, the device in question is

00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset Integrated Graphics Controller (rev 03)                                                                       
        Subsystem: ASUSTeK Computer Inc. Device 8276                                      
        Flags: bus master, fast devsel, latency 0, IRQ 27                                 
        Memory at fe400000 (64-bit, non-prefetchable) [size=4M]                           
        Memory at d0000000 (64-bit, prefetchable) [size=256M]                             
        I/O ports at cc00 [size=8]                                                        
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+   
        Capabilities: [d0] Power Management version 2                                     
        Capabilities: [a4] PCIe advanced features <?>                                     
        Kernel driver in use: i915                                                        
00: 86 80 22 2e 07 04 90 00 03 00 00 03 00 00 80 00                                       
10: 04 00 40 fe 00 00 00 00 0c 00 00 d0 00 00 00 00                                       
20: 01 cc 00 00 00 00 00 00 00 00 00 00 43 10 76 82                                       
30: 00 00 00 00 90 00 00 00 00 00 00 00 0a 01 00 00                                       

00:02.1 Display controller: Intel Corporation 4 Series Chipset Integrated Graphics Controller (rev 03)                                                                              
        Subsystem: ASUSTeK Computer Inc. Device 8276                                      
        Flags: bus master, fast devsel, latency 0                                         
        Memory at fe800000 (64-bit, non-prefetchable) [size=1M]                           
        Capabilities: [d0] Power Management version 2                                     
00: 86 80 23 2e 07 00 90 00 03 00 80 03 00 00 80 00                                       
10: 04 00 80 fe 00 00 00 00 00 00 00 00 00 00 00 00                                       
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 76 82                                       
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00     

Let me know if you have a patch you want me to test.

Thanks,

	Arnd                                  
