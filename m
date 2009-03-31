Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZCaDw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZCaDw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbZCaDwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:52:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41170 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZCaDwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:52:45 -0400
Date: Tue, 31 Mar 2009 09:21:40 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dhaval Giani <dhaval.lists@thegianis.in>,
       linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090331035140.GC4199@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1231338965-796-1-git-send-email-jirislaby@gmail.com> <20090107152208.GB4207@linux.vnet.ibm.com> <4964CAAA.3040801@gmail.com> <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com> <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com> <20090330085952.GB3837@linux.vnet.ibm.com> <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com> <20090330175951.GB4199@linux.vnet.ibm.com> <b6c5339f0903301113y6cb0b8bu1eaa55439eb18d97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6c5339f0903301113y6cb0b8bu1eaa55439eb18d97@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:13:35PM -0400, Bob Copeland wrote:
> On Mon, Mar 30, 2009 at 1:59 PM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > ok, so my kernel does hve this patch applied, and this is what I get,
> >
> >  ------------[ cut here ]------------
> >  WARNING: at include/net/mac80211.h:1956 minstrel_get_rate+0xa1/0x4b9 [mac80211]()
> 
> I believe this is something different (tx path not rx).  I think it's
> that minstrel rate table bug again, which we never solved for ath5k.
> 
> Are you using adhoc or managed mode?  Do you have the slab/slub debugging
> options turned on?  Any steps that consistently reproduce it?  Do you
> get any warnings with PID controller?
> 

[dhaval@gondor ~]$ iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:"linksys_SES_62338"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:1A:70:D6:2D:06
          Bit Rate=36 Mb/s   Tx-Power=23 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Power Management:off
          Link Quality=100/100  Signal level:-49 dBm  Noise level=-96 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

[dhaval@gondor ~]$

[dhaval@gondor linux-2.6]$ grep -i slub .config
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
[dhaval@gondor linux-2.6]$

Am not sure what the PID controller is, and google gave me a number of
results, which did not make too much sense in the context.

Yes, I think I know how to reproduce it, but I am not sure what is the
real cause.

One way I have found of reproducing it is to connect to open networks,
but it does not happen always. At home, when my network is set to open,
I do not see this issue, whereas at the airport, kaboom.

I've also seen it on LEAP networks, but there were also a few open
networks around. This warning is generally accompanied by a disconnect
from the LEAP connected network, and then the system reconnects. Let me
know if you have patches, I can give them a run and report back.

Thanks,
-- 
regards,
Dhaval
