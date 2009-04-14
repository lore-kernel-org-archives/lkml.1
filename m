Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZDNAHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZDNAHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZDNAHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:07:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55590 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZDNAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:07:35 -0400
Date: Tue, 14 Apr 2009 02:06:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: alan-jenkins@tuffmail.co.uk, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090414000627.GL817@elte.hu>
References: <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu> <49E367E8.7080202@zytor.com> <9b2b86520904131134y26f508ffr2bc0303eff203a25@mail.gmail.com> <49E38DBD.8040303@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E38DBD.8040303@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> Alan Jenkins wrote:
>> IIRC, the first person to report the issue found that it triggered
>> when hotplugging a HDMI cable.
>
> Oh, that's right.  Either we were invoking the video BIOS from the 
> kernel (which we do actually do sometimes) -- in which case we 
> have control over when it happens -- or there is commingling of 
> the video BIOS and mainboard BIOS combined with SMM crap.  Joy.

The corruption pattern in the bugzilla:

    http://bugzilla.kernel.org/show_bug.cgi?id=11237

... looks like an x86 descriptor table. Does the pattern below make 
any sense to anyone? I've attached the relevant bits of one of the 
reports below.

	Ingo

[   28.414367] Corrupted low memory at c000c000 (c000 phys) = 02062004
[   28.414367] Corrupted low memory at c000c004 (c004 phys) = 0000003a
[   28.414367] Corrupted low memory at c000c008 (c008 phys) = 00208000
[   28.414367] Corrupted low memory at c000c00c (c00c phys) = 3e88c6fd
[   28.414367] Corrupted low memory at c000c018 (c018 phys) = 0000004a
[   28.414367] Corrupted low memory at c000c01c (c01c phys) = aaaaaa00
[   28.414367] Corrupted low memory at c000c020 (c020 phys) = 00000644
[   28.414367] Corrupted low memory at c000c024 (c024 phys) = 00000140
[   28.414367] Corrupted low memory at c000c028 (c028 phys) = ffffffff
[   28.414367] Corrupted low memory at c000c02c (c02c phys) = ffffffff
[   28.414367] Corrupted low memory at c000c030 (c030 phys) = ffffffff
[   28.414367] Corrupted low memory at c000c034 (c034 phys) = ffffffff
[   28.414367] Corrupted low memory at c000c038 (c038 phys) = ffffffff
[   28.414367] Corrupted low memory at c000c03c (c03c phys) = ffffffff
[   28.414367] Corrupted low memory at c000c040 (c040 phys) = 00fffbff
[   28.414367] Corrupted low memory at c000c044 (c044 phys) = fd9035c3
[   28.414367] Corrupted low memory at c000c048 (c048 phys) = a9fe7bf8
[   28.414367] Corrupted low memory at c000c04c (c04c phys) = 3f00ff0f
[   28.414367] Corrupted low memory at c000c050 (c050 phys) = c7ffdffe
[   28.414367] Corrupted low memory at c000c054 (c054 phys) = 3c03bc1e
[   28.414367] Corrupted low memory at c000c058 (c058 phys) = 00d62480
[   28.414367] Corrupted low memory at c000c05c (c05c phys) = fffffe14
[   28.414367] Corrupted low memory at c000c060 (c060 phys) = eb1fe1fe
[   28.414367] Corrupted low memory at c000c064 (c064 phys) = ff3cf64c
[   28.414367] Corrupted low memory at c000c068 (c068 phys) = 807f879f
[   28.414367] Corrupted low memory at c000c06c (c06c phys) = f0266027
[   28.414367] Corrupted low memory at c000c070 (c070 phys) = 18fe1d74
[   28.414367] Corrupted low memory at c000c074 (c074 phys) = 6b122000
[   28.414367] Corrupted low memory at c000c078 (c078 phys) = e7fffbcf
[   28.414367] Corrupted low memory at c000c07c (c07c phys) = 0ff0f3f0
[   28.414367] Corrupted low memory at c000c080 (c080 phys) = 9fffee3f
[   28.414367] Corrupted low memory at c000c084 (c084 phys) = 1bc3e440
[   28.414367] Corrupted low memory at c000c088 (c088 phys) = 07fc01fe
[   28.414367] Corrupted low memory at c000c08c (c08c phys) = ff0dfe00
[   28.414367] Corrupted low memory at c000c090 (c090 phys) = ebe00035
[   28.414367] Corrupted low memory at c000c094 (c094 phys) = 3fe00ff0
[   28.414367] Corrupted low memory at c000c098 (c098 phys) = f86ff007
[   28.414367] Corrupted low memory at c000c09c (c09c phys) = ff803fc0
[   28.414367] Corrupted low memory at c000c0a0 (c0a0 phys) = e1bfc01f
[   28.414367] Corrupted low memory at c000c0a4 (c0a4 phys) = fe00ff03
[   28.414367] Corrupted low memory at c000c0a8 (c0a8 phys) = 86ff007f
[   28.414367] Corrupted low memory at c000c0ac (c0ac phys) = 78001a30
[   28.414367] Corrupted low memory at c000c0b0 (c0b0 phys) = f007f81f
[   28.414367] Corrupted low memory at c000c0b4 (c0b4 phys) = 37f803fc
[   28.414367] Corrupted low memory at c000c0b8 (c0b8 phys) = c01fe07f
[   28.414367] Corrupted low memory at c000c0bc (c0bc phys) = dfe00ff0
[   28.414367] Corrupted low memory at c000c0c0 (c0c0 phys) = 007f81ff
[   28.414367] Corrupted low memory at c000c0c4 (c0c4 phys) = 7f803fc3
[   28.414367] Corrupted low memory at c000c0c8 (c0c8 phys) = 000f7ffc
[   28.414367] Corrupted low memory at c000c0cc (c0cc phys) = 03fc0ff8
[   28.414367] Corrupted low memory at c000c0d0 (c0d0 phys) = fc01fe1b
[   28.414367] Corrupted low memory at c000c0d4 (c0d4 phys) = 0ff03fe0
[   28.414367] Corrupted low memory at c000c0d8 (c0d8 phys) = f007f86f
[   28.414367] Corrupted low memory at c000c0dc (c0dc phys) = 3fc0ff80
[   28.414367] Corrupted low memory at c000c0e0 (c0e0 phys) = c01fe1bf
[   28.414367] Corrupted low memory at c000c0e4 (c0e4 phys) = 07bffe00
[   28.414367] Corrupted low memory at c000c0e8 (c0e8 phys) = fe07fc01
[   28.414367] Corrupted low memory at c000c0ec (c0ec phys) = 00ff0dfe
[   28.414367] Corrupted low memory at c000c0f0 (c0f0 phys) = f81ff007
[   28.414367] Corrupted low memory at c000c0f4 (c0f4 phys) = 03fc37f8
[   28.414367] Corrupted low memory at c000c0f8 (c0f8 phys) = e07fc01f
[   28.414367] Corrupted low memory at c000c0fc (c0fc phys) = 0ff0dfe0
[   28.414367] Corrupted low memory at c000c100 (c100 phys) = dfff0003
[   28.414367] Corrupted low memory at c000c104 (c104 phys) = 03fe00ff
[   28.414367] Corrupted low memory at c000c108 (c108 phys) = 7f86ff00
[   28.414367] Corrupted low memory at c000c10c (c10c phys) = 0ff803fc
[   28.414367] Corrupted low memory at c000c110 (c110 phys) = fe1bfc01
[   28.414367] Corrupted low memory at c000c114 (c114 phys) = 3fe00ff0
[   28.414367] Corrupted low memory at c000c118 (c118 phys) = f86ff007
[   28.414367] Corrupted low memory at c000c11c (c11c phys) = ff8001ef
[   28.414367] Corrupted low memory at c000c120 (c120 phys) = ff007f81
[   28.414367] Corrupted low memory at c000c124 (c124 phys) = c37f803f
[   28.414367] Corrupted low memory at c000c128 (c128 phys) = fc01fe07
[   28.414367] Corrupted low memory at c000c12c (c12c phys) = 0dfe00ff
[   28.414367] Corrupted low memory at c000c130 (c130 phys) = f007f81f
[   28.414367] Corrupted low memory at c000c134 (c134 phys) = 37f803fc
[   28.414367] Corrupted low memory at c000c138 (c138 phys) = c000f7ff
[   28.414367] Corrupted low memory at c000c13c (c13c phys) = 803fc0ff
[   28.414367] Corrupted low memory at c000c140 (c140 phys) = bfc01fe1
[   28.414367] Corrupted low memory at c000c144 (c144 phys) = 00ff03fe
[   28.414367] Corrupted low memory at c000c148 (c148 phys) = ff007f86
[   28.414367] Corrupted low memory at c000c14c (c14c phys) = 03fc0ff8
[   28.414367] Corrupted low memory at c000c150 (c150 phys) = fc01fe1b
[   28.414367] Corrupted low memory at c000c154 (c154 phys) = 007bffe0
[   28.414367] Corrupted low memory at c000c158 (c158 phys) = 1fe07fc0
[   28.414367] Corrupted low memory at c000c15c (c15c phys) = e00ff0df
[   28.414367] Corrupted low memory at c000c160 (c160 phys) = 7f81ff00
[   28.414367] Corrupted low memory at c000c164 (c164 phys) = 803fc37f
[   28.414367] Corrupted low memory at c000c168 (c168 phys) = fe07fc01
[   28.414367] Corrupted low memory at c000c16c (c16c phys) = 00ff0dfe
[   28.414367] Corrupted low memory at c000c170 (c170 phys) = 3dfff000
[   28.414367] Corrupted low memory at c000c174 (c174 phys) = f03fe00f
[   28.414367] Corrupted low memory at c000c178 (c178 phys) = 07f86ff0
[   28.414367] Corrupted low memory at c000c17c (c17c phys) = c0ff803f
[   28.414367] Corrupted low memory at c000c180 (c180 phys) = 1fe1bfc0
[   28.414367] Corrupted low memory at c000c184 (c184 phys) = 03fe00ff
[   28.414367] Corrupted low memory at c000c188 (c188 phys) = 7f86ff00
[   28.414367] Corrupted low memory at c000c18c (c18c phys) = fff8001e
[   28.414367] Corrupted low memory at c000c190 (c190 phys) = 1ff007f8
[   28.414367] Corrupted low memory at c000c194 (c194 phys) = fc37f803
[   28.414367] Corrupted low memory at c000c198 (c198 phys) = 7fc01fe0
[   28.414367] Corrupted low memory at c000c19c (c19c phys) = f0dfe00f
[   28.414367] Corrupted low memory at c000c1a0 (c1a0 phys) = ff007f81
[   28.414367] Corrupted low memory at c000c1a4 (c1a4 phys) = c37f803f
[   28.414367] Corrupted low memory at c000c1a8 (c1a8 phys) = fc000f7f
[   28.414367] Corrupted low memory at c000c1ac (c1ac phys) = f803fc0f
[   28.414367] Corrupted low memory at c000c1b0 (c1b0 phys) = 1bfc01fe
[   28.414367] Corrupted low memory at c000c1b4 (c1b4 phys) = e00ff03f
[   28.414367] Corrupted low memory at c000c1b8 (c1b8 phys) = 6ff007f8
[   28.414367] Corrupted low memory at c000c1bc (c1bc phys) = 803fc0ff
[   28.414367] Corrupted low memory at c000c1c0 (c1c0 phys) = bfc01fe1
[   28.414367] Corrupted low memory at c000c1c4 (c1c4 phys) = 0007bffe
[   28.414367] Corrupted low memory at c000c1c8 (c1c8 phys) = 01fe07fc
[   28.414367] Corrupted low memory at c000c1cc (c1cc phys) = fe00ff0d
[   28.414367] Corrupted low memory at c000c1d0 (c1d0 phys) = 07f81ff0
[   28.414367] Corrupted low memory at c000c1d4 (c1d4 phys) = f803fc37
[   28.414367] Corrupted low memory at c000c1d8 (c1d8 phys) = 1fe07fc0
[   28.414367] Corrupted low memory at c000c1dc (c1dc phys) = e00ff0df
[   28.414367] Corrupted low memory at c000c1e0 (c1e0 phys) = 03dfff00
[   28.414367] Corrupted low memory at c000c1e4 (c1e4 phys) = ff03fe00
[   28.414367] Corrupted low memory at c000c1e8 (c1e8 phys) = 007f86ff
[   28.414367] Corrupted low memory at c000c1ec (c1ec phys) = fc0ff803
[   28.414367] Corrupted low memory at c000c1f0 (c1f0 phys) = 01fe1bfc
[   28.414367] Corrupted low memory at c000c1f4 (c1f4 phys) = f03fe00f
[   28.414367] Corrupted low memory at c000c1f8 (c1f8 phys) = 07f86ff0
[   28.414367] Corrupted low memory at c000c1fc (c1fc phys) = efff8001
[   28.414367] Corrupted low memory at c000c200 (c200 phys) = 81ff007f
[   28.414367] Corrupted low memory at c000c204 (c204 phys) = 3fc37f80
[   28.414367] Corrupted low memory at c000c208 (c208 phys) = 07fc01fe
[   28.414367] Corrupted low memory at c000c20c (c20c phys) = ff0dfe00
[   28.414367] Corrupted low memory at c000c210 (c210 phys) = 1ff007f8
[   28.414367] Corrupted low memory at c000c214 (c214 phys) = fc37f803
[   28.414367] Corrupted low memory at c000c218 (c218 phys) = ffc000f7
[   28.414367] Corrupted low memory at c000c21c (c21c phys) = ff803fc0
[   28.414367] Corrupted low memory at c000c220 (c220 phys) = e1bfc01f
[   28.414367] Corrupted low memory at c000c224 (c224 phys) = fe00ff03
[   28.414367] Corrupted low memory at c000c228 (c228 phys) = 86ff007f
[   28.414367] Corrupted low memory at c000c22c (c22c phys) = f803fc0f
[   28.414367] Corrupted low memory at c000c230 (c230 phys) = 1bfc01fe
[   28.414367] Corrupted low memory at c000c234 (c234 phys) = e0007bff
[   28.414367] Corrupted low memory at c000c238 (c238 phys) = c01fe07f
[   28.414367] Corrupted low memory at c000c23c (c23c phys) = dfe00ff0
[   28.414367] Corrupted low memory at c000c240 (c240 phys) = 007f81ff
[   28.414367] Corrupted low memory at c000c244 (c244 phys) = 7f803fc3
[   28.414367] Corrupted low memory at c000c248 (c248 phys) = 01fe07fc
[   28.414367] Corrupted low memory at c000c24c (c24c phys) = fe00ff0d
[   28.414367] Corrupted low memory at c000c250 (c250 phys) = 003dfff0
[   28.414367] Corrupted low memory at c000c254 (c254 phys) = 0ff03fe0
[   28.414367] Corrupted low memory at c000c258 (c258 phys) = f007f86f
[   28.414367] Corrupted low memory at c000c25c (c25c phys) = 3fc0ff80
[   28.414367] Corrupted low memory at c000c260 (c260 phys) = c01fe1bf
[   28.414367] Corrupted low memory at c000c264 (c264 phys) = ff03fe00
[   28.414367] Corrupted low memory at c000c268 (c268 phys) = 007f86ff
[   28.414367] Corrupted low memory at c000c26c (c26c phys) = 1efff800
[   28.414367] Corrupted low memory at c000c270 (c270 phys) = f81ff007
[   28.414367] Corrupted low memory at c000c274 (c274 phys) = 03fc37f8
[   28.414367] Corrupted low memory at c000c278 (c278 phys) = e07fc01f
[   28.414367] Corrupted low memory at c000c27c (c27c phys) = 0ff0dfe0
[   28.414367] Corrupted low memory at c000c280 (c280 phys) = 81ff007f
[   28.414367] Corrupted low memory at c000c284 (c284 phys) = 3fc37f80
[   28.414367] Corrupted low memory at c000c288 (c288 phys) = 7ffc000f
[   28.414367] Corrupted low memory at c000c28c (c28c phys) = 0ff803fc
[   28.414367] Corrupted low memory at c000c290 (c290 phys) = fe1bfc01
[   28.414367] Corrupted low memory at c000c294 (c294 phys) = 3fe00ff0
[   28.414367] Corrupted low memory at c000c298 (c298 phys) = f86ff007
[   28.414367] Corrupted low memory at c000c29c (c29c phys) = ff803fc0
[   28.414367] Corrupted low memory at c000c2a0 (c2a0 phys) = e1bfc01f
[   28.414367] Corrupted low memory at c000c2a4 (c2a4 phys) = fe0007bf
[   28.414367] Corrupted low memory at c000c2a8 (c2a8 phys) = fc01fe07
[   28.414367] Corrupted low memory at c000c2ac (c2ac phys) = 0dfe00ff
[   28.414367] Corrupted low memory at c000c2b0 (c2b0 phys) = f007f81f
[   28.414367] Corrupted low memory at c000c2b4 (c2b4 phys) = 37f803fc
[   28.414367] Corrupted low memory at c000c2b8 (c2b8 phys) = c01fe07f
[   28.414367] Corrupted low memory at c000c2bc (c2bc phys) = dfe00ff0
[   28.414367] Corrupted low memory at c000c2c0 (c2c0 phys) = 0003dfff
[   28.414367] Corrupted low memory at c000c2c4 (c2c4 phys) = 00ff03fe
[   28.414367] Corrupted low memory at c000c2c8 (c2c8 phys) = ff007f86
[   28.414367] Corrupted low memory at c000c2cc (c2cc phys) = 03fc0ff8
[   28.414367] Corrupted low memory at c000c2d0 (c2d0 phys) = fc01fe1b
[   28.414367] Corrupted low memory at c000c2d4 (c2d4 phys) = 0ff03fe0
[   28.414367] Corrupted low memory at c000c2d8 (c2d8 phys) = f007f86f
[   28.414367] Corrupted low memory at c000c2dc (c2dc phys) = 01efff80
[   28.414367] Corrupted low memory at c000c2e0 (c2e0 phys) = 7f81ff00
[   28.414367] Corrupted low memory at c000c2e4 (c2e4 phys) = 803fc37f
[   28.414367] Corrupted low memory at c000c2e8 (c2e8 phys) = fe07fc01
[   28.414367] Corrupted low memory at c000c2ec (c2ec phys) = 00ff0dfe
[   28.414367] Corrupted low memory at c000c2f0 (c2f0 phys) = f81ff007
[   28.414367] Corrupted low memory at c000c2f4 (c2f4 phys) = 03fc37f8
[   28.414367] Corrupted low memory at c000c2f8 (c2f8 phys) = f7ffc000
[   28.414367] Corrupted low memory at c000c2fc (c2fc phys) = c0ff803f
[   28.414367] Corrupted low memory at c000c300 (c300 phys) = 1fe1bfc0
[   28.414367] Corrupted low memory at c000c304 (c304 phys) = 03fe00ff
[   28.414367] Corrupted low memory at c000c308 (c308 phys) = 7f86ff00
[   28.414367] Corrupted low memory at c000c30c (c30c phys) = 0ff803fc
[   28.414367] Corrupted low memory at c000c310 (c310 phys) = fe1bfc01
[   28.414367] Corrupted low memory at c000c314 (c314 phys) = ffe0007b
[   28.414367] Corrupted low memory at c000c318 (c318 phys) = 7fc01fe0
[   28.414367] Corrupted low memory at c000c31c (c31c phys) = f0dfe00f
[   28.414367] Corrupted low memory at c000c320 (c320 phys) = ff007f81
[   28.414367] Corrupted low memory at c000c324 (c324 phys) = c37f803f
[   28.414367] Corrupted low memory at c000c328 (c328 phys) = fc01fe07
[   28.414367] Corrupted low memory at c000c32c (c32c phys) = 0dfe00ff
[   28.414367] Corrupted low memory at c000c330 (c330 phys) = f0003dff
[   28.414367] Corrupted low memory at c000c334 (c334 phys) = e00ff03f
[   28.414367] Corrupted low memory at c000c338 (c338 phys) = 6ff007f8
[   28.414367] Corrupted low memory at c000c33c (c33c phys) = 803fc0ff
[   28.414367] Corrupted low memory at c000c340 (c340 phys) = bfc01fe1
[   28.414367] Corrupted low memory at c000c344 (c344 phys) = 00ff03fe
[   28.414367] Corrupted low memory at c000c348 (c348 phys) = ff007f86
[   28.414367] Corrupted low memory at c000c34c (c34c phys) = 001efff8
[   28.414367] Corrupted low memory at c000c350 (c350 phys) = 07f81ff0
[   28.414367] Corrupted low memory at c000c354 (c354 phys) = f803fc37
[   28.414367] Corrupted low memory at c000c358 (c358 phys) = 1fe07fc0
[   28.414367] Corrupted low memory at c000c35c (c35c phys) = e00ff0df
[   28.414367] Corrupted low memory at c000c360 (c360 phys) = 7f81ff00
[   28.414367] Corrupted low memory at c000c364 (c364 phys) = 803fc37f
[   28.414367] Corrupted low memory at c000c368 (c368 phys) = 0f7ffc00
[   28.414367] Corrupted low memory at c000c36c (c36c phys) = fc0ff803
[   28.414367] Corrupted low memory at c000c370 (c370 phys) = 01fe1bfc
[   28.414367] Corrupted low memory at c000c374 (c374 phys) = f03fe00f
[   28.414367] Corrupted low memory at c000c378 (c378 phys) = 07f86ff0
[   28.414367] Corrupted low memory at c000c37c (c37c phys) = c0ff803f
[   28.414367] Corrupted low memory at c000c380 (c380 phys) = 1fe1bfc0
[   28.414367] Corrupted low memory at c000c384 (c384 phys) = bffe0007
[   28.414367] Corrupted low memory at c000c388 (c388 phys) = 07fc01fe
[   28.414367] Corrupted low memory at c000c38c (c38c phys) = ff0dfe00
[   28.414367] Corrupted low memory at c000c390 (c390 phys) = 1ff007f8
[   28.414367] Corrupted low memory at c000c394 (c394 phys) = fc37f803
[   28.414367] Corrupted low memory at c000c398 (c398 phys) = 7fc01fe0
[   28.414367] Corrupted low memory at c000c39c (c39c phys) = f0dfe00f
[   28.414367] Corrupted low memory at c000c3a0 (c3a0 phys) = ff0003df
[   28.414367] Corrupted low memory at c000c3a4 (c3a4 phys) = fe00ff03
[   28.414367] Corrupted low memory at c000c3a8 (c3a8 phys) = 86ff007f
[   28.414367] Corrupted low memory at c000c3ac (c3ac phys) = f803fc0f
[   28.414367] Corrupted low memory at c000c3b0 (c3b0 phys) = 1bfc01fe
[   28.414367] Corrupted low memory at c000c3b4 (c3b4 phys) = e00ff03f
[   28.414367] Corrupted low memory at c000c3b8 (c3b8 phys) = 6ff007f8
[   28.414367] Corrupted low memory at c000c3bc (c3bc phys) = 8001efff
[   28.414367] Pid: 2217, comm: suspend-steph Not tainted 2.6.27-rc6 #2
[   28.414367]  [<c02485eb>] dpm_power_up+0x33/0x96
[   28.414367]  [<c01431e1>] suspend_devices_and_enter+0xc3/0x11c
[   28.414367]  [<c014333c>] enter_state+0xc3/0x113
[   28.414367]  [<c0143413>] state_store+0x87/0x9a
[   28.414367]  [<c014338c>] state_store+0x0/0x9a
[   28.414367]  [<c01e6687>] kobj_attr_store+0x18/0x1c
[   28.414367]  [<c01b3fc6>] sysfs_write_file+0xb0/0xdd
[   28.414367]  [<c01b3f16>] sysfs_write_file+0x0/0xdd
[   28.414367]  [<c017a87f>] vfs_write+0x84/0x121
[   28.414367]  [<c017a9b4>] sys_write+0x3c/0x63
[   28.414367]  [<c01038a3>] sysenter_do_call+0x12/0x2f
[   28.414367]  =======================
[   28.416720] ACPI: Waking up from system sleep state S3
