Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbZIPCfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbZIPCfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZIPCfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:35:48 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:12134 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZIPCfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:35:48 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8
 a=qFacP82rfxASQFVkNCkA:9 a=-3hFlsewhNkLz428WiIA:7
 a=fL1ByFC7nFVoOW6hqNbRqf6Ci3wA:4 a=x8gzFH9gYPwA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: Tricks to speed up kernel builds
Date: Tue, 15 Sep 2009 20:35:50 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-git4; KDE/4.3.1; x86_64; ; )
References: <4AAF4ECD.5010401@pardus.org.tr>
In-Reply-To: <4AAF4ECD.5010401@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909152035.50814.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue September 15 2009, Ozan Çağlayan wrote:
> Hi,
> 
> I'd googled a lot about the $subject but couldn't find any detailed
> guide about it. So, the followings are what I understand from what I've
> found:
> 
> 1. Build inside a tmpfs to avoid I/O bottlenecks,
> 2. Use ccache,
> 3. Switch governor to performance if supported,
> 4. Pass -j to gnu make to parallelize the build process,
> 5. Don't build debug symbols a.k.a set CONFIG_DEBUG_INFO=n
> 6. There are a bunch of sched patches in tip which apparently improves
> things during kbuild
> 7. Distribute the work into the local network using icecream, distcc.
> 
> For the -j part, how many jobs should we pass to it? I've seen people
> passing
> 
> - NR_of_cores+1
> - NR_of_cores x 2 (I think that this is useful when there's 2 threads of
> execution per core like HyperThreading?)
> - 64, 128, etc. regardless of the number of cores (Is it really useful
> regardless of the CPU)
> 
> The curious question is *what build times can you get* with your typical
> systems using your speedup tricks (quad core, dual core, etc.) ? What
> are other tricks that I can use to even more speed up the build?
> 
> Do you really use icecream/distcc on your daily test builds?
> 
> How about nicing/ionicing make on an idle system? Will it make any
> difference?

I've only done a few compiles recently, and I only really use icecream and 
make -jX to speed up compile times.

I have a 4 node icecc cluster, three quad cores (one limited to 2 cores), and 
one dual core (limited to a single core), which gives 11 total cores I can 
distribute to, and I usually pass: make -j12

Any higher and I don't really see any speedups, any lower, same difference.

My last kernel compile (2.6.31-git4) took about 9 minutes.

> Thanks a lot
> Ozan Caglayan
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
