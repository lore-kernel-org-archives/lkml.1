Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZAKVj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZAKVj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZAKVjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:39:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38330
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752924AbZAKVj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:39:29 -0500
Date: Sun, 11 Jan 2009 13:39:29 -0800 (PST)
Message-Id: <20090111.133929.57600645.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: Valdis.Kletnieks@vt.edu, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1231676698.25018.147.camel@macbook.infradead.org>
References: <43805.1231672258@turing-police.cc.vt.edu>
	<20090111.040842.86784676.davem@davemloft.net>
	<1231676698.25018.147.camel@macbook.infradead.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Sun, 11 Jan 2009 12:24:58 +0000

> Other drivers will load the firmware later, at the time the device is
> brought up. This means that even if you build the driver into the kernel
> without its firmware, it can still request the firmware later, when you
> try to start _using_ it. And when the file system is available.

For example, for mounting an NFS root using that device.... Oh, will I
need an initramfs for that once you pull the firmware-in-kernel
option?

To me, device probe is in fact the place to fail firmware discovery
for networking devices.  Because such a failure can mean you can't
mount your root filesystem.
