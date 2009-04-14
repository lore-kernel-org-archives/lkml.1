Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZDNVL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZDNVL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZDNVLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:11:34 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37875 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZDNVLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:11:32 -0400
Date: Tue, 14 Apr 2009 14:11:25 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Patrick McHardy <kaber@trash.net>,
       paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       paulus@samba.org, mingo@elte.hu, torvalds@linux-foundation.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v2)
Message-ID: <20090414141125.53af6fdc@nehalam>
In-Reply-To: <49E4E3E8.5090201@cosmosbay.com>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
	<18913.53699.544083.320542@cargo.ozlabs.ibm.com>
	<20090412173108.GO6822@linux.vnet.ibm.com>
	<20090412.181330.23529546.davem@davemloft.net>
	<20090413040413.GQ6822@linux.vnet.ibm.com>
	<20090413095309.631cf395@nehalam>
	<49E48136.5060700@trash.net>
	<49E49C65.8060808@cosmosbay.com>
	<20090414074554.7fa73e2f@nehalam>
	<49E4B0A5.70404@cosmosbay.com>
	<b6a2187b0904140951r3c6a41fdnc26b149202bdfa84@mail.gmail.com>
	<20090414111716.28585806@nehalam>
	<49E4E3E8.5090201@cosmosbay.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh well, it seems factorization of this stuff is not what you want, so
> I'll stop arguing.

That's no fun..  I didn't mind the refactorizing, but was concerned
that it caused the locking to be out of line in fast path. 
