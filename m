Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbZHJTG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbZHJTG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZHJTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:06:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZHJTG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:06:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fischer, Anna" <anna.fischer@hp.com>
Subject: Re: [Bridge] [PATCH] macvlan: add tap device backend
Date: Mon, 10 Aug 2009 21:04:54 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>,
       "drobbins@funtoo.org" <drobbins@funtoo.org>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ogerlitz@voltaire.com" <ogerlitz@voltaire.com>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "davem@davemloft.net" <davem@davemloft.net>
References: <0199E0D51A61344794750DC57738F58E6D6A6CD7F6@GVW1118EXC.americas.hpqcorp.net> <200908080005.32443.arnd@arndb.de> <0199E0D51A61344794750DC57738F58E6D6AE99700@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6AE99700@GVW1118EXC.americas.hpqcorp.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908102104.54527.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/M9eKrv0zP8dyOfImRRhhqS+jarPHjJHPF7FO
 l+Psr6xFszCWgAq03g+AMTwT61/f0hsS0XOmvwue8+kdmZMKPJ
 0ZSU5eb1k/sar7a3w12TQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 August 2009, Fischer, Anna wrote:
> If you compare macvtap with traditional QEMU networking interfaces that
> are typically used in current bridged setups, then yes, performance will be
> different. However, I think that this is not necessarily a fair 
> comparison, and the performance difference does not come from the 
> bridge being slow, but simply because you have implemented a better
> solution to connect a virtual interface to a backend device that
> can be assigned to a VM. There is no reason why you could not do this
> for a bridge port as well.

It's not necessarily the bridge itself being slow (though some people
claim it is) but more the bridge preventing optimizations or making
them hard.

You already mentioned hardware filtering by unicast and multicast
mac addresses, which macvlan already does (for unicast) but which would be
relatively complex with a bridge due to the way it does MAC address
learning.

If we want to do zero copy receives, the hardware will on top of
this have to choose the receive buffer based on the mac address,
with the buffer provided by the guest. I think this is not easy
with macvlan but doable, while I have no idea where you would start
using the bridge code.

	Arnd <><
