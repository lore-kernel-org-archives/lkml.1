Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167Ab0ASCxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0ASCxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 21:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822Ab0ASCxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 21:53:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:49222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0ASCxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 21:53:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,300,1262592000"; 
   d="scan'208";a="588278609"
From: "Du, Alek" <alek.du@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Julia Lawall <julia@diku.dk>
CC: Andreas Mohr <andi@lisas.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 19 Jan 2010 10:53:11 +0800
Subject: RE: mcs7830 usb net: "scheduling while atomic" danger?
Thread-Topic: mcs7830 usb net: "scheduling while atomic" danger?
Thread-Index: AcqYhSWMYu3B6j5vTRCaPo3dIyM1KQALRS6Q
Message-ID: <ED3036A092A28F4C91B0B4360DD128EA35987814@shzsmsx502.ccr.corp.intel.com>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
 <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk>
 <201001182223.49764.arnd@arndb.de>
In-Reply-To: <201001182223.49764.arnd@arndb.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I confirm that thing is bad, I need to prepare another patch to fix that.

Thanks,
Alek
>-----Original Message-----
>From: Arnd Bergmann [mailto:arnd@arndb.de]
>Sent: Tuesday, January 19, 2010 5:24 AM
>To: Julia Lawall
>Cc: Andreas Mohr; linux-kernel@vger.kernel.org; Greg KH; Du, Alek; Pan, Jacob
>jun; Alan Stern
>Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
>
>On Monday 18 January 2010, Julia Lawall wrote:
>> On Mon, 18 Jan 2010, Andreas Mohr wrote:
>> >
>> > Forgive me, but doesn't that mutex_lock()/msleep() (ab)use mean
>> > risking a "scheduling while atomic"?
>> > (such as discussed in e.g.
>> > http://search.luky.org/linux-kernel.2004/msg92817.html )
>> >
>> >
>> > And, if that is the case, shouldn't all such cases simply be killed for
>> > good via a capable semantic patch?
>>
>> The semantic match shown below finds 55 matches.  All but two involve
>> mutex_lock.  Those are in the file
>> /var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
>> in the functions ehci_bus_suspend and ehci_hub_control.
>
>That code looks indeed broken as was added las July as part of 331ac6b288d9
>"USB: EHCI: Add Intel Moorestown EHCI controller HOSTPCx extensions and
>support phy low power mode". The reason that this hasn't triggered is
>probably the lack of Moorestown machines in the field.
>
>	Arnd
