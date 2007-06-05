Return-Path: <linux-kernel-owner+w=401wt.eu-S1764144AbXFEJYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764144AbXFEJYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763229AbXFEJYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:24:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52361 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761905AbXFEJYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:24:20 -0400
Date: Tue, 5 Jun 2007 02:24:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
Message-Id: <20070605022411.f303d28b.akpm@linux-foundation.org>
In-Reply-To: <20070605091151.GA18385@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070605091151.GA18385@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 11:11:51 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> hm, mm1 hangs during bootup on one of my boxes:
> 
>  Calling initcall 0xc0628d39: pci_mmcfg_late_insert_resources+0x0/0x44()
>  initcall 0xc0628d39: pci_mmcfg_late_insert_resources+0x0/0x44() returned 0.
>  initcall 0xc0628d39 ran for 0 msecs: 
>  pci_mmcfg_late_insert_resources+0x0/0x44()
>  Calling initcall 0xc062abd1: tcp_congestion_default+0x0/0xf()
>  initcall 0xc062abd1: tcp_congestion_default+0x0/0xf() returned 0.
>  initcall 0xc062abd1 ran for 0 msecs: tcp_congestion_default+0x0/0xf()
> 
> it usually hangs in different places.

In my experience that means that it wedged in a timer tick.  Often the first
one.


> Full bootlog below. Same kernel 
> bzImage boots fine on another box.
> 
> the NMI watchdog warning is a bit weird:
> 
>  Calling initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8()
>  Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
>  CPU#1: NMI appears to be stuck (0->0)!
>  initcall 0xc0613e4f: check_nmi_watchdog+0x0/0x1a8() returned -1.
>  initcall 0xc0613e4f ran for 27 msecs: check_nmi_watchdog+0x0/0x1a8()
> 
> i'll test it in a minute with that turned off.
> 

hm.  I haven't seen any similar reports.
