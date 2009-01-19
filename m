Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZASWeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZASWeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZASWeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:34:00 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39766 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZASWd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=wlA/SguF+bFLRkXh99SlM5geeMdRjqU7FYLFLDs7auR9UAn4CrpOlM/VmBB44PKfHs
         BU38xCLBjqIbMjUNoQC8vCCHwoTWqetzYW6dB4XaLJ5U3eQj3jm5eGTB2wGVNHH7DHtC
         NdffVSJkw0AGZOjtnS9bpHkBIyYZxx7bbFGTQ=
MIME-Version: 1.0
In-Reply-To: <8b67d60901181626l43a8728fh6f2a2ab146b45d90@mail.gmail.com>
References: <8b67d60901181626l43a8728fh6f2a2ab146b45d90@mail.gmail.com>
Date: Mon, 19 Jan 2009 22:33:57 +0000
Message-ID: <8b67d60901191433u51d062bgffa523c7da811cb8@mail.gmail.com>
Subject: Re: Bug: Latest (rc2 and beyond) kernel fails on Dreamcast
From: Adrian McMenamin <lkmladrian@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Adrian McMenamin <lkmladrian@gmail.com>:
> I haven't had time to look at this, but the most up to date kernel
> (and the one of around a week ago also) fails to boot, seemingly
> seeking an IP address for the 8139too based NIC.

> [    4.664236] Sending DHCP requests .<3>eth0: PCI Bus error 2200.
> [    4.669582] eth0: PCI Bus error 2200.
> [    4.673395] eth0: PCI Bus error 2200.
> [    4.677152] eth0: PCI Bus error 2200.
> [    4.680905] eth0: PCI Bus error 2200.
> [    4.684677] eth0: PCI Bus error 2200.
> [    4.688450] eth0: PCI Bus error 2200.
> [    4.692245] eth0: PCI Bus error 2200.
> [    4.695944] eth0: PCI Bus error 2200.
> [    4.699767] eth0: PCI Bus error 2200.
> [    4.703540] eth0: PCI Bus error 2200.
> [    4.707336] eth0: PCI Bus error 2200.
> [    4.711086] eth0: PCI Bus error 2200.
> [    4.714858] eth0: PCI Bus error 2200.
> [    4.718630] eth0: PCI Bus error 2200.
> [    4.722415] eth0: PCI Bus error 2200.
> [    4.726187] eth0: PCI Bus error 2200.
> [    4.729948] eth0: PCI Bus error 2200.
> [    4.733720] eth0: PCI Bus error 2200.
> [    4.737492] eth0: PCI Bus error 2200.
> [    4.741288] eth0: PCI Bus error 2200.
> [    4.745038] eth0: PCI Bus error 2200.
> [    4.748810] eth0: PCI Bus error 2200.
>
> and so on ... quite possibly for ever. Will investigate further.
>

And the bisection reveals the following:

adrian@bossclass:~/linux-2.6$ git bisect bad
58c6d3dfe436eb8cfb451981d8fdc9044eaf42da is first bad commit
commit 58c6d3dfe436eb8cfb451981d8fdc9044eaf42da
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Tue Jan 6 14:43:10 2009 -0800

    dma-coherent: catch oversized requests to dma_alloc_from_coherent()

    Prevent passing an order to bitmap_find_free_region() that is larger than
    the actual bitmap can represent.

    These requests can come from device drivers that have no idea how big the
    dma region is and need to rely on dma_alloc_from_coherent() to sort it out
    for them.

    Reported-by: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Pekka Enberg <penberg@cs.helsinki.fi>
    Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
    Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 5c8a694b778f36a3254103d99cb73b561cb84565
5efd4e32eb145f32ca4e96aefbea08f4f8f4d27d M	kernel
