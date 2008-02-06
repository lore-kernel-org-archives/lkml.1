Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbYBFIeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbYBFIeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbYBFIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:34:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759042AbYBFIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:34:10 -0500
Date: Wed, 6 Feb 2008 00:34:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: locking api self-test hanging
Message-Id: <20080206003412.dca555d4.akpm@linux-foundation.org>
In-Reply-To: <20080204044304.d244e761.akpm@linux-foundation.org>
References: <20080203150246.50647fa4.akpm@linux-foundation.org>
	<20080203150744.cf7d0415.akpm@linux-foundation.org>
	<20080204044304.d244e761.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 04:43:04 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 3 Feb 2008 15:07:44 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 3 Feb 2008 15:02:46 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > With current mainline I'm getting intermittent hangs here:
> > > 
> > > 	http://userweb.kernel.org/~akpm/p2033590.jpg
> > > 
> > > with this config:
> > > 
> > > 	http://userweb.kernel.org/~akpm/config-sony.txt
> > > 
> > > on the Vaio.  Sometimes it boots (then hits another different hang),
> > > sometimes it gets stuck there.
> 
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=n fixed that up.
> 
> > 
> > The second hang is in kobject_uevent_init().  All that function does is call
> > netlink_kernel_create().
> 
> And I've fully bisected this hang twice and both times came up with
> 
> commit 33f807ba0d9259e7c75c7a2ce8bd2787e5b540c7
> Author: Stephen Hemminger <shemminger@linux-foundation.org>
> Date:   Mon Nov 19 19:24:52 2007 -0800
> 
>     [NETPOLL]: Kill NETPOLL_RX_DROP, set but never tested.
> 
> which is stupid because that patch doesn't do anything.
> 
> However I am using netconsole-over-e100 and the hang does go away when I
> disable netconsole on the kernel boot command line.
> 
> I'd say it's some timing thing in netpoll/netconsole/napi/etc.
> 

I'm seeing this netconsole hang on a second machine now.  Current
mainline.  It also has e100.  This one is SMP ancient PIII.

Config: http://userweb.kernel.org/~akpm/config-vmm.txt

