Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXIORlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXIORlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXIORlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:41:37 -0400
Received: from tag.witbe.net ([81.88.96.48]:57426 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbXIORlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:41:36 -0400
Date: Sat, 15 Sep 2007 19:41:29 +0200
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: "Rob Hussey" <robjhussey@gmail.com>
Cc: eric.valette@free.fr, flamingice@sourmilk.net, andreamrl@tiscali.it,
       linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
Message-ID: <20070915194129.458febd3@tux.DEF.witbe.net>
In-Reply-To: <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
References: <46EBE70C.2040201@free.fr>
	<46EBEBD2.7060502@free.fr>
	<6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
Organization: Witbe.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Sat, 15 Sep 2007 12:28:36 -0400
"Rob Hussey" <robjhussey@gmail.com> wrote:

> On 9/15/07, Eric Valette <eric.valette@free.fr> wrote:
> > Eric Valette wrote:
> >
> > > I can probably take a picture of the backtrace if you want.
> >
> > Just saw that just above my message in the LKML web interface, someone
> > posted a backtrace. Mine is different but at least, we are at least two
> > to have the crash.
> 
> This is the same thing I said to Paul Rolland, since I think your
> problems are the same:
> I had this problem as well. It has to do with mac80211, cfg80211 and
> the rate control algorithm not initializing early enough in the boot
> process. These two patches should fix it:
> 
> [PATCH] mac80211: fix initialisation when built-in
> http://article.gmane.org/gmane.linux.kernel.wireless.general/5710/match=patch+mac80211+initialisation
> 
> [PATCH] cfg80211: fix initialisation if built-in
> http://article.gmane.org/gmane.linux.network/71326/match=patch+cfg80211+initialisation
> 

Too bad gmane patches can't be applied directly, they seems to contain
very strange <at> inside....
However, manually patching seems to be Ok. Kernel is now booting 
correctly, and I have :
...
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com> 
All bugs added by David S. Miller <davem@redhat.com> 
ieee80211: 802.11 data/management/control stack, git-1.1.13 
ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com> 
ieee80211_crypt: registered algorithm 'NULL' 
ieee80211_crypt: registered algorithm 'WEP' 
ieee80211_crypt: registered algorithm 'CCMP' 
ieee80211_crypt: registered algorithm 'TKIP'
...

and after some iwconfig configuration steps, I have :

wlan0     Link encap:Ethernet  HWaddr
00:15:AF:0F:D7:90 inet addr:192.168.1.34  Bcast:192.168.1.255
Mask:255.255.255.0 inet6 addr: fe80::215:afff:fe0f:d790/64
Scope:Link UP BROADCAST RUNNING MULTICAST  MTU:1500
Metric:1 RX packets:15 errors:0 dropped:0 overruns:0
frame:0 TX packets:15 errors:0 dropped:0 overruns:0 carrier:0                 
          collisions:0
txqueuelen:1000 RX bytes:4798 (4.6 KiB)  TX bytes:4566 (4.4
KiB)

These two patches are a "must be" for 2.6.23 !!!

Eric, feel confident, it seems really to do the trick, and the changes are
subtle and mostly harmless.

Regards,
Paul
