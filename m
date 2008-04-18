Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYDRK26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYDRK26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYDRK2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:28:50 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42837 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbYDRK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:28:49 -0400
Date: Fri, 18 Apr 2008 13:30:22 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Bob Copeland <me@bobcopeland.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <20080414004521.GA30489@hash.localnet>
Message-ID: <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
 <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet>
 <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org>
 <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org>
 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 13 Apr 2008, Bob Copeland wrote:

> I don't have hard numbers, but anecdotally my FUSE version is quite 
> a bit less performant.  That's no criticism of FUSE - I just haven't
> put the time into optimizing and adding various caches.

Thankfully you need none, it's already there by FUSE and the kernel. The 
trick is exactly that you can have the kernel performance and the left is 
moved to user space with typically negligible performance overhead which is 
usually well compensated with faster delivered new features and bug fixes.

The completely unoptimized ntfs-3g read/write saturates my USB disks with 
25-30 MB/sec using 8% (read), 35% (write) CPU time on a 2.5 GHz Core 2 Duo 
with cold caches.

If you have the free hot caches then it performs the same as in-kernel 
file systems, user space isn't involved at all.

I noticed that the OMFS kernel driver supports only the USB interface and 
the FUSE one both the network and the USB one. Isn't it possible that you 
compared the performance using the USB with the kernel vs the much slower 
and lower latency network with FUSE? You should compare performances using 
only the USB interface in both cases.

If you did use the USB interface with FUSE then what exactly do you mean by 
"quite a bit less performance" in numbers and workloads? What you did, how 
long it took using what CPU?

Thanks,
	    Szaka

-- 
NTFS-3G:  http://ntfs-3g.org
