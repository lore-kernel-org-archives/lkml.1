Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbXJMSTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbXJMSTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbXJMSTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:19:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762388AbXJMSTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:19:07 -0400
Date: Sat, 13 Oct 2007 11:18:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Kuan Luo" <kluo@nvidia.com>,
       "Peer Chen" <pchen@nvidia.com>
Subject: Re: 2.6.23-mm1
Message-Id: <20071013111853.7e67c6c3.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071012013729.ada2127b.akpm@linux-foundation.org>
	<64bb37e0710130101y7fb8e4c0lf214fd821e8305ed@mail.gmail.com>
	<4710A407.3070000@garzik.org>
	<64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>
	<4710B7C5.5050403@garzik.org>
	<64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
	<64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	<64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	<47110500.8050503@garzik.org>
	<64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 20:05:19 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> The only thing I noted during load testing (updating Gentoo ==
> compiling and installing) was, that there seems to be memory leak.
> After ~2h 2.5 of my 4Gb where gone. But there where to many things
> going on to pinpoint it... (NFSv4 over eth1394?)

Please send /proc/meminfo and /proc/slabinfo after the leak has been
happening for a while.

Sometimes `echo m > /proc/sysrq_trigger ; dmesg -s 1000000' will
provide useful info.

The page-owner code can pinpoint a leak source.  See
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/broken-out/page-owner-tracking-leak-detector.patch

Enable CONFIG_DEBUG_SLAB_LEAK, check out /proc/slab_allocators
