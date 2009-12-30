Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZL3II4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZL3II4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 03:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZL3IIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 03:08:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbZL3IIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 03:08:55 -0500
Date: Wed, 30 Dec 2009 00:07:24 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
Message-ID: <20091230000724.4083e7dd@nehalam>
In-Reply-To: <20091223230102.4bb0100e.akpm@linux-foundation.org>
References: <4B300A2A.8040305@gmail.com>
	<4B300E30.9090707@majjas.com>
	<4B3114E3.1070602@majjas.com>
	<4B329FA3.9090904@majjas.com>
	<20091223230102.4bb0100e.akpm@linux-foundation.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009 23:01:02 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Dec 23 17:32:58 mail kernel: DRHD: handling fault status reg 2
> > Dec 23 17:32:58 mail kernel: DMAR:[DMA Read] Request device [06:00.0] 
> > fault addr fff8423fe000
> > Dec 23 17:32:58 mail kernel: DMAR:[fault reason 06] PTE Read access is 
> > not set
> > Dec 23 17:32:58 mail kernel: sky2 0000:06:00.0: error interrupt 
> > status=0x80000000
> > Dec 23 17:32:58 mail kernel: sky2 0000:06:00.0: PCI hardware error (0x2010)
> > Dec 23 17:33:06 mail kernel: ------------[ cut here ]------------
> > Dec 23 17:33:06 mail kernel: WARNING: at net/sched/sch_generic.c:255 
> > dev_watchdog+0xf3/0x161()
> > Dec 23 17:33:06 mail kernel: Hardware name: System Product Name
> > Dec 23 17:33:06 mail kernel: NETDEV WATCHDOG: eth0 (sky2): transmit 

Just to reiterate, these are consistent with a DMA error on transmit.
Since is 4 seconds after the DHCPACK, they probably are not related, except
that when DHCP renew may have caused more traffic.

Are you using something like network console or kgdb, or anything that could
be using some unusual network I/O?
