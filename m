Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZHJQRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZHJQRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZHJQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:16:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbZHJQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:16:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fischer, Anna" <anna.fischer@hp.com>
Subject: Re: [evb] Re: [PATCH][RFC] net/bridge: add basic VEPA support
Date: Mon, 10 Aug 2009 18:16:08 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "'Stephen Hemminger'" <shemminger@linux-foundation.org>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "kaber@trash.net" <kaber@trash.net>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "'Or Gerlitz'" <ogerlitz@voltaire.com>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net> <200908101723.10832.arnd@arndb.de> <0199E0D51A61344794750DC57738F58E6D6AE99867@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6AE99867@GVW1118EXC.americas.hpqcorp.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101816.08287.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/J10SPL5K7nIypQnnXje+OUTCvQxdVO7VIW17
 pRjGjXbrhhV4DPWqki+ZWR8mdobukPQd2MeoDhaJkHWtc67/Wm
 gsiCsblN/UxajCFdHr33A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Fischer, Anna wrote:
> On the VEPA filtering service side, the only change we have implemented
> in the bridging code is that in VEPA mode all frames are passed to the
> uplink on TX. However, frames are still passed through the netfilter 
> hooks before they go out on the wire. On the inbound path, there are
> no changes to the way frames are processed (except the filtering for
> the original source port), so netfilter hooks work in the same way
> as for a normal bridge.

Ah, interesting. I did not realize that the hooks were still active,
although that obviously makes sense. So that would be another
important difference between our implementations.

> If a frame is reflected back because of a hairpin turn, then of course
> the incoming port is the VEPA uplink port and not the port that
> originally sent the frame. So if you are trying to enforce some
> packet filtering on that inbound path, then you would have to do that
> based on MAC addresses and not on bridge ports. But I would assume that
> you would enforce the filtering already before you send out the frame
> to the adjacent bridge. Apart from that, if you enable your bridge to
> behave in VEPA mode, then you would typically do packet filtering etc
> on the adjacent bridge and not use the netfilter hook. You can still use
> both though, if you like.

Right, that was my point. They bridge in VEPA mode would likely be
configured to be completely ignorant of the data going through it
and not do any filter, and you do all filterring on the adjacent
bridge.

I just wasn't sure that this is possible with ebtables if the
adjacent bridge is a Linux system with the bridge in hairpin turn
mode.

	Arnd <><
