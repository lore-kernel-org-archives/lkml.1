Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZKFD1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZKFD1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 22:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZKFD1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 22:27:51 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:42608 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZKFD1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 22:27:50 -0500
Date: Fri, 6 Nov 2009 04:27:55 +0100
From: Tobias Diedrich <ranma@tdiedrich.de>
To: linux-kernel@vger.kernel.org
Subject: Re: netconsole: tulip: possible remote DoS? due to kernel freeze
	on heavy RX traffic after Order-1 allocation failure
Message-ID: <20091106032754.GA15429@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	linux-kernel@vger.kernel.org
References: <20091105113106.GA4373@yumi.tdiedrich.de> <1257450578.2873.609.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257450578.2873.609.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> > Example from netconsole log:
> > |perl: page allocation failure. order:1, mode:0x20
> > |Pid: 3541, comm: perl Tainted: G        W  2.6.30.9-tomodachi #16
> > |Call Trace:
> > | [<c013e56d>] ? __alloc_pages_internal+0x353/0x36f
> > | [<c0154f2c>] ? cache_alloc_refill+0x2ab/0x544
> > | [<c0355479>] ? dev_alloc_skb+0x11/0x25
> > | [<c015526f>] ? __kmalloc_track_caller+0xaa/0xf9
> > | [<c0354ae5>] ? __alloc_skb+0x48/0xff
> > | [<c0355479>] ? dev_alloc_skb+0x11/0x25
> > | [<c02d4ba9>] ? tulip_refill_rx+0x3c/0x115
> > | [<c02d4fff>] ? tulip_poll+0x37d/0x416
> > | [<c0359763>] ? net_rx_action+0x6b/0x12f
> > | [<c0121ad7>] ? __do_softirq+0x4e/0xbf
> > | [<c0121a89>] ? __do_softirq+0x0/0xbf
> > | <IRQ>  [<c0107700>] ? do_IRQ+0x53/0x63
> > | [<c0106610>] ? common_interrupt+0x30/0x38
> 
> I don't see anything in this trace to implicate netconsole? This is the
> normal network receive path running out of input buffers then running
> into memory fragmentation.

I'm just thinking the hang might be related to using netconsole.
I guess I should try reproducing it without it.
Or is it normal that a box will hang if the network receive path runs out of
input buffers?
Why does it allocate Order-1 buffers anyway?
AFAICS tulip only supports MTU 1500 on this, so I don't see why it
has to allocate 2 contiguous pages?

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
