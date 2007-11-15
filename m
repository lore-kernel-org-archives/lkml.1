Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbXKOKoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbXKOKoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbXKOKoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:44:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56797 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbXKOKoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:44:09 -0500
Date: Thu, 15 Nov 2007 11:43:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071115104331.GA11390@elte.hu>
References: <20071114225335.GV19691@waste.org> <20071114.151013.05582536.davem@davemloft.net> <20071114233713.GW19691@waste.org> <20071114.154143.112110604.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114.154143.112110604.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Matt Mackall <mpm@selenic.com>
> Date: Wed, 14 Nov 2007 17:37:13 -0600
> 
> > No, the usual strategy for debugging problems -outside- SLOB is to
> > switch to another allocator with more extensive debugging facilities.
> 
> Ok, so the thing we still can do is do a dump_stack() at the list 
> debugging assertion trigger points.

ok, i'll first try to trigger it again.

it's a bzImage kernel with fixed order of eth0 and eth1 detection. What 
i did was to twiddle the /etc/sysconfig/network-scripts/ifcfg-eth* 
configs to address a network-does-not-show-up bug that .24 introduced. 
The crash logs contain this:

 VFS: Mounted root (ext3 filesystem) readonly.
 Freeing unused kernel memory: 396k freed
 Write protecting the kernel read-only data: 2056k
 udev: renamed network interface eth1 to eth0
 udev: renamed network interface eth0_rename to eth1
 eth0: link down
 ADDRCONF(NETDEV_UP): eth0: link is not ready
 EXT3 FS on sda6, internal journal
 kjournald starting.  Commit interval 5 seconds

followed by the crash shortly afterwards (but not immediately). With the 
non-crashing kernel i dont get those "renamed network interface" 
messages.

network interface renaming has been a historic source of pain for me so 
i frequently have to 'twiddle' the networking config to make it work 
again on new kernels. Perhaps because i'm using bzImage kernels. 
User-space is Fedora 8, so fairly recent.

	Ingo
