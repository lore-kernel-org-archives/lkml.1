Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXF2Iuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXF2Iuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXF2Iu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:50:27 -0400
Received: from mail.xandmail.com ([212.155.184.97]:57526 "EHLO
	mail.xandmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbXF2IuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:50:25 -0400
Date: Fri, 29 Jun 2007 10:50:20 +0200
Message-Id: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>
To: "jarkao2" <jarkao2@o2.pl>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>,
       "shemminger" <shemminger@linux-foundation.org>,
       "linux-net" <linux-net@vger.kernel.org>,
       "netdev" <netdev@vger.kernel.org>
X-XaM3-API-Version: 4.2(R3) (B21)
X-type: 0
X-SenderIP: 212.155.184.109
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update...
I did 2 tests :

1)  booted with option acpi=off
It booted correctly, i managed to get some load on one of the card and after a while (10 minutes i guess) the Timeout occurs. Side effect, at the same moment the sata contolers lost control of the disks somehow and the raid 5 array on the system crashed hard. I have no traces as i was unable to rebuild it (and i tried a lot of extreme  voodoo methods).

2) changed the 3com cards
i replaced by two cards,
01:06.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 42)
01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8029(AS)

reinstalled and stressed the network (small download from a laptop) and :

Jun 29 09:34:10 loki kernel: NETDEV WATCHDOG: eth0: transmit timed out
Jun 29 09:34:51 loki last message repeated 14 times
Jun 29 09:35:18 loki last message repeated 8 times

so it seems to be a more generic problem.

(i'v updated the fedora bugzilla aswell)

did not test the  "[PATCH] 8139cp dev->tx_timeout" yet.

JB


> On Tue, Jun 26, 2007 at 04:24:07PM +0200, Jean-Baptiste Vignaud wrote:
> > Hello, i have a very similar problem with 2.6.21 also;
> > 
> > 2 3com NICs and they are failling randomly.
> > 
> > The kernel is a basic fedora 7 kernel (2.6.21-1.3228.fc7)
> > I found a bug report and added details here : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243960
> > 
> > I'm not subcribed on this list, so please cc me if there is any questions.
> > 
> > JB
> > 
> > > On Tue, Jun 26, 2007 at 08:10:17AM +0200, Marcin Ślusarz wrote:
> > > ...
> > > > I reproduced it on minimal config:
> ...
> > > We know your hardware should be OK - since it was fine with 2.6.20.
> ...
> 
> It looks like there is something common in the air...
> 
> Marcin: ne2k_pci with 8390, Jean: 3com, and now I see
> similar problem with 8139cp too (plus some ideas):
> 
> http://marc.info/?l=linux-netdev&m=118293314109648&w=2
> 
> So, you probably should wait a little & look for new patches here.
> 
> Cheers,
> Jarek P.
> 

