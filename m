Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbYKXHfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbYKXHfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 02:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKXHev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 02:34:51 -0500
Received: from smtp6-g19.free.fr ([212.27.42.36]:50070 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYKXHeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 02:34:50 -0500
Message-ID: <492A5913.3070007@free.fr>
Date: Mon, 24 Nov 2008 08:34:43 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Derek Smithies <derek@indranet.co.nz>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, wally@theblackmoor.net
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>	<alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com>
In-Reply-To: <4927FC0C.10900@gmail.com>
X-Enigmail-Version: 0.95.7
OpenPGP: url=http://benoit.papillault.free.fr/pgp/benoit.papillault.pgp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Maxim Levitsky a écrit :
> Derek Smithies wrote:
>> Hi,
>>  to verify that it is a rate control issue, there is one very simple and 
>> very practical test.
>>
>> Take both ends of your link, and set them to fixed rate, and at the rate 
>> you think it should be achieving.
>> If you can achieve significantly higher throughputs with fixed rate, you 
>> know that the rate control algorithm (or interface with rate algorithm) 
>> has failed.
>>
>> Derek.
>>
>> On Fri, 21 Nov 2008, Bob Copeland wrote:
>>
>>> On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
>>>> I initially blamed iwl3945, then thought it got fixed, but now I have
>>>> ath5k, and speeds are low
>>>> and I suspect that both drivers has bugs regarding to speed.
>>> Quite possible, but both use mac80211 for rate control.  Which rate
>>> control algorithm are you using?
> Hi,
> 
> Well, iwl3945 was showing 54M all the time in iwconfig,
> also it doesn't support setting fixed rate, at least not using iwconfig.
> 
> ath5k never shows higher that 18M, and supports setting fixed rate, but if I set it to anything higher that 18M,
> speeds drop to 0Kbytes/s immediately.
> Speeds lower that 18M work, and affect throughput accordantly
> For most of tests speeds are ether 18M or lower, but then when I set them to 18M this didn't increase throughput.
>  
> iwl3945 was always at 54M
> 
> 
> 
> Best regards,
> 	Maxim Levitsky

I did a similar test here and results is very strange. AP was my good
old linksys WRT54G running an iperf server. Client was a laptop running
either ath5k or madwifi/trunk and an iperf client. Channel is 5. Both
drivers show the same behaviour.

At the beginning, throughput was very low : 500 - 600 kbit/s. Suddenly
(after few minutes), it jumps to 15 - 17 Mbit/s and then few minutes
later (let's say 10 - 20 minutes maybe), it jumps back to 500 - 600
kbit/s. Using a fixed rate has no effect.

I used my latest wireless monitoring tools and I did not saw lost of
duplicates or lost packets. The only difference was the number of
packets sent by seconds....

Looking a my syslog, I just saw few messages, unrelated in time with the
throughput going up or down. They were:
- - ath5k : unsupported jumbo
- - switching to short barker preamble
- - switching to long barker preamble

I can repeat the same test with iwl3945 as well, if needed.

Regards,
Benoît
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJKlkTOR6EySwP7oIRAnR1AJ0UCiENM0qtZwQYngkVpiLvrKtgLACfRKPz
Wi/HreSX4NV+kfyeS+RMFaY=
=RKcV
-----END PGP SIGNATURE-----
