Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZBYOB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZBYOB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZBYOBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:01:47 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49194 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZBYOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:01:45 -0500
Date: Wed, 25 Feb 2009 14:01:39 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090225140139.GA18694@silver.sucs.org>
References: <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49A46AD4.3060007@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 10:47:00PM +0100, Jiri Slaby wrote:
> 
> I added a check for this in rx tasklet some time ago, because I hit it. 
> So no fireworks really should happen ;).
> 
> And yes, we ought to use this much better test (I knew nothing about 
> AR_RXDP reg) than mine.

It has been days since the original BUG occurred and further it
originally had happened in a -tip kernel with kmemcheck compiled into
it. I had been utterly unable to reproduce the error on any network with
a stock 2.6.29-rc6 kernel. Not even the original -tip kernel produced
the error again...

Until just now - the bug reappeared in 2.6.29-rc6 on a different network
to the original report. This time the spiteful "unsupported jumbo"
messages are not too close to the site of the error. Further this time
it happened some time after a resume from suspend (but last time I don't
think I had suspended since boot at all).

[ 1606.129379] PM: Finishing wakeup.
[ 1606.129383] Restarting tasks ... done.
[ 1611.537545] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[ 1626.032420] wlan0: authenticate with AP 00:1a:1e:e6:cd:60
[ 1626.033808] wlan0: authenticated
[ 1626.033815] wlan0: associate with AP 00:1a:1e:e6:cd:60
[ 1626.037962] wlan0: RX AssocResp from 00:1a:1e:e6:cd:60 (capab=0x431 status=0 aid=1)
[ 1626.038029] wlan0: associated
[ 1741.029383] ath5k phy0: noise floor calibration failed (2462MHz)
[ 2164.890685] ath5k phy0: unsupported jumbo
[ 2419.118202] wlan0: No ProbeResp from current AP 00:1a:1e:e6:cd:60 - assume out of range
[ 2420.602342] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 try 1
[ 2420.602475] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 try 1
[ 2420.602548] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 try 1
[ 2420.802195] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 try 2
[ 2421.022578] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 try 3
[ 2421.222279] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 timed out
[ 2443.258402] wlan0: direct probe to AP 00:1a:1e:e6:cd:60 try 1
[ 2443.289471] wlan0: authenticate with AP 00:13:80:aa:36:81
[ 2443.292227] wlan0: authenticated
[ 2443.292235] wlan0: associate with AP 00:13:80:aa:36:81
[ 2443.299590] wlan0: RX AssocResp from 00:13:80:aa:36:81 (capab=0x431 status=0 aid=117)
[ 2443.299597] wlan0: associated
[ 2469.305184] wlan0: No ProbeResp from current AP 00:13:80:aa:36:81 - assume out of range
[ 2470.735409] wlan0: direct probe to AP 00:13:80:aa:36:81 try 1
[ 2470.735547] wlan0: direct probe to AP 00:13:80:aa:36:81 try 1
[ 2470.735620] wlan0: direct probe to AP 00:13:80:aa:36:81 try 1
[ 2470.935207] wlan0: direct probe to AP 00:13:80:aa:36:81 try 2
[ 2471.135191] wlan0: direct probe to AP 00:13:80:aa:36:81 try 3
[ 2471.335187] wlan0: direct probe to AP 00:13:80:aa:36:81 timed out
[ 2681.733971] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 2702.734367] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 2723.734343] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 2734.734520] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 2766.733898] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 2777.734523] ath5k phy0: noise floor calibration timeout (2462MHz)
[ 3204.214423] wlan0: authenticate with AP 00:03:52:c1:86:e0
[ 3204.216400] wlan0: authenticated
[ 3204.216407] wlan0: associate with AP 00:03:52:c1:86:e0
[ 3204.222674] wlan0: RX AssocResp from 00:03:52:c1:86:e0 (capab=0x431 status=0 aid=6)
[ 3204.222681] wlan0: associated
[ 3265.195472] wlan0 direct probe responded
[ 3265.195483] wlan0: authenticate with AP 00:03:52:c1:86:e0
[ 3265.198018] wlan0: authenticated
[ 3265.198025] wlan0: associate with AP 00:03:52:c1:86:e0
[ 3265.200818] wlan0: RX ReassocResp from 00:03:52:c1:86:e0 (capab=0x431 status=0 aid=6)
[ 3265.200825] wlan0: associated
[ 3335.425723] wlan0: disassociating by local choice (reason=3)
[ 3336.801565] wlan0: authenticate with AP 00:03:52:c1:86:e0
[ 3336.801709] wlan0: authenticate with AP 00:03:52:c1:86:e0
[ 3336.801781] wlan0: authenticate with AP 00:03:52:c1:86:e0
[ 3336.804733] wlan0: authenticated
[ 3336.804741] wlan0: associate with AP 00:03:52:c1:86:e0
[ 3336.809592] wlan0: RX ReassocResp from 00:03:52:c1:86:e0 (capab=0x431 status=0 aid=2)
[ 3336.809599] wlan0: associated
[ 4074.998435] =============================================================================
[ 4074.998447] BUG kmalloc-4096: Poison overwritten
[ 4074.998452] -----------------------------------------------------------------------------
[ 4074.998455] 
[ 4074.998460] INFO: 0xf21fe130-0xf21fe17b. First byte 0x80 instead of 0x6b
[ 4074.998477] INFO: Allocated in dev_alloc_skb+0x21/0x40 age=923 cpu=0 pid=0
[ 4074.998485] INFO: Freed in skb_release_data+0x5e/0x90 age=1 cpu=0 pid=0
[ 4074.998492] INFO: Slab 0xc1643f00 objects=7 used=3 fp=0xf21fe120 flags=0x400020c3
[ 4074.998498] INFO: Object 0xf21fe120 @offset=24864 fp=0xf21f9030
[ 4074.998500] 
[ 4074.998504] Bytes b4 0xf21fe110:  00 00 00 00 af 95 39 00 5a 5a 5a 5a 5a 5a 5a 5a ....�.9.ZZZZZZZZ
[ 4074.998534]   Object 0xf21fe120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998562]   Object 0xf21fe130:  80 00 00 00 ff ff ff ff ff ff 00 03 52 dc 7a 81 ....������..R�z.
[ 4074.998590]   Object 0xf21fe140:  00 03 52 dc 7a 81 f0 be 86 25 3c 1c 00 00 00 00 ..R�z.��.%<.....
[ 4074.998618]   Object 0xf21fe150:  64 00 21 04 00 03 4e 41 53 01 08 82 84 8b 96 0c d.!...NAS.......
[ 4074.998646]   Object 0xf21fe160:  12 18 24 03 01 06 05 04 00 01 00 00 2a 01 02 32 ..$.........*..2
[ 4074.998674]   Object 0xf21fe170:  04 30 48 60 6c a0 bb b7 55 a0 bb 55 6b 6b 6b 6b .0H`l.��U.�Ukkkk
[ 4074.998702]   Object 0xf21fe180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998730]   Object 0xf21fe190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998758]   Object 0xf21fe1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998786]   Object 0xf21fe1b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998814]   Object 0xf21fe1c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998842]   Object 0xf21fe1d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998870]   Object 0xf21fe1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998898]   Object 0xf21fe1f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998926]   Object 0xf21fe200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998954]   Object 0xf21fe210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.998982]   Object 0xf21fe220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999010]   Object 0xf21fe230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999038]   Object 0xf21fe240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999066]   Object 0xf21fe250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999094]   Object 0xf21fe260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999122]   Object 0xf21fe270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999150]   Object 0xf21fe280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999178]   Object 0xf21fe290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999206]   Object 0xf21fe2a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999234]   Object 0xf21fe2b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999262]   Object 0xf21fe2c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999290]   Object 0xf21fe2d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999318]   Object 0xf21fe2e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999346]   Object 0xf21fe2f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999374]   Object 0xf21fe300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe3a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe3b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe3c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe3d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe3e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe3f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe4a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe4b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe4c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe4d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe4e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe4f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe5a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe5b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe5c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe5d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe5e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe5f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe6a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe6d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe7a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe7c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe7f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe8a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe8b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe8c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe8d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe8e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe8f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe9a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe9b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe9c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe9d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe9e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fe9f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fea90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feaa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fead0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feaf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feb90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21febb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21febc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21febd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21febe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21febf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fec90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fecb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fecc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fecd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fece0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fecf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fed90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feda0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fedb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fedc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fedd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fede0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fedf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fee90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feeb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fef90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fefa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fefb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fefc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fefd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21fefe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21feff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff0a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff0b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff0c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff0d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff0e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff0f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 4074.999390]   Object 0xf21ff110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
[ 4074.999390]  Redzone 0xf21ff120:  bb bb bb bb                                     ����            
[ 4074.999390]  Padding 0xf21ff148:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[ 4074.999390] Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc6 #67
[ 4074.999390] Call Trace:
[ 4074.999390]  [<c01815a4>] print_trailer+0xb4/0xf0
[ 4074.999390]  [<c0181687>] check_bytes_and_report+0xa7/0xd0
[ 4074.999390]  [<c018241e>] check_object+0x1ae/0x1f0
[ 4074.999390]  [<c018324f>] __slab_alloc+0x46f/0x510
[ 4074.999390]  [<c0184237>] __kmalloc_track_caller+0x127/0x130
[ 4074.999390]  [<c0387081>] ? dev_alloc_skb+0x21/0x40
[ 4074.999390]  [<c0387081>] ? dev_alloc_skb+0x21/0x40
[ 4074.999390]  [<c03869fe>] __alloc_skb+0x4e/0x100
[ 4074.999390]  [<c0387081>] dev_alloc_skb+0x21/0x40
[ 4074.999390]  [<c02e4518>] ath5k_rx_skb_alloc+0x28/0x180
[ 4074.999390]  [<c04073be>] ? _spin_lock+0x3e/0x50
[ 4074.999390]  [<c02e5d4d>] ath5k_tasklet_rx+0x15d/0x700
[ 4074.999390]  [<c01489bb>] ? trace_hardirqs_off+0xb/0x10
[ 4074.999390]  [<c040788c>] ? _spin_unlock_irqrestore+0x3c/0x60
[ 4074.999390]  [<c0142aba>] ? update_wall_time+0x29a/0x7c0
[ 4074.999390]  [<c02dcbdb>] ? ath5k_hw_get_isr+0x6b/0x3d0
[ 4074.999390]  [<c0116a62>] ? read_hpet+0x12/0x20
[ 4074.999390]  [<c02dcf67>] ? ath5k_hw_is_intr_pending+0x27/0x60
[ 4074.999390]  [<c012d4b4>] tasklet_action+0x44/0x90
[ 4074.999390]  [<c012d015>] __do_softirq+0x65/0x110
[ 4074.999390]  [<c012d115>] do_softirq+0x55/0x60
[ 4074.999390]  [<c012d3fc>] irq_exit+0x6c/0x80
[ 4074.999390]  [<c01051d7>] do_IRQ+0x57/0xb0
[ 4074.999390]  [<c010396c>] common_interrupt+0x2c/0x34
[ 4074.999390]  [<c027928c>] ? acpi_idle_enter_bm+0x1ec/0x21d
[ 4074.999390]  [<c035460c>] cpuidle_idle_call+0x6c/0xc0
[ 4074.999390]  [<c0101ebb>] cpu_idle+0x4b/0x70
[ 4074.999390]  [<c03fbebd>] rest_init+0x4d/0x60
[ 4074.999390] FIX kmalloc-4096: Restoring 0xf21fe130-0xf21fe17b=0x6b
[ 4074.999390] 
[ 4074.999390] FIX kmalloc-4096: Marking all objects used
[ 4203.999111] ath5k phy0: unsupported jumbo

NAS is the name of a nearby access point. This is really tough to
reproduce but if there's anything (e.g. ftrace) I can always turn on
that will help you track this thing down let me know. Unfortunately the
machine is an EeePC 900 so any logging would have to be cyclic and held
in RAM...

-- 
Sitsofe | http://sucs.org/~sits/
