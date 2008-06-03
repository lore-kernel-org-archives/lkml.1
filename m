Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbYFCUzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbYFCUzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYFCUyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:54:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42616
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYFCUyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:54:53 -0400
Date: Tue, 03 Jun 2008 13:54:49 -0700 (PDT)
Message-Id: <20080603.135449.193702216.davem@davemloft.net>
To: airlied@gmail.com
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970806031345u4e7838fdp60bbedadd65b5f2a@mail.gmail.com>
References: <20080603.062253.17158135.davem@davemloft.net>
	<18501.39659.952880.727014@alkaid.it.uu.se>
	<21d7e9970806031345u4e7838fdp60bbedadd65b5f2a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Wed, 4 Jun 2008 06:45:57 +1000

> Wow thats a major userspace regression to ship, we'd never get away
> with doing that on x86 platforms.

x86 has how many maintainers and contributors last time you checked?

Meanwhile X itself shipped mostly-non-working for PCI devices on sparc
for years.  And would you also not argue that it's broken to begin
with that the older X servers cannot work properly without a root PCI
controller being there?

The only way I can work around this issue is to provide a virtual host
bridge driver in the kernel, and I tried to do that, but it doesn't
work which is why the change got installed that did.

We'd need this because on many sparc64 machines the PCI host bridge
(and some sub-bridges) aren't even accessible via PCI config space.

If you provide a virtual host bridge, you have to emulate all of
the PCI config space accesses, you have to provide the expected
linkage and hierarchy with the rest of the PCI devices, and you
also have to do all of the I/O and MEM space range bits correctly
too.

For PCI-E and sub-bridges this becomes even more complicated, and
frankly a waste of time.

In short you have to implement an entire non-trivial emulation layer
for this stuff.

I'm the only sparc64 platform developer, so my time is better spent
moving forward and making sure that libpciaccess based X servers
aren't so broken and do the right thing in a way which works in a
maintainable long term manner.
