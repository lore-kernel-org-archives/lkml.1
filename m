Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZFHNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZFHNHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFHNHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:07:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZFHNHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:07:04 -0400
Date: Mon, 8 Jun 2009 15:06:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       John Dykstra <john.dykstra1@gmail.com>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH net-next-2.6] net: dev_addr_init() fix
Message-ID: <20090608130653.GB3272@elte.hu>
References: <19f34abd0905301323k1498ca3fv31b271de65d60afc@mail.gmail.com> <1244408607.9064.8.camel@Maple> <19f34abd0906080300w796c6b65o6b537064cac917b0@mail.gmail.com> <4A2CEB9E.7080109@gmail.com> <4A2D006C.70302@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A2D006C.70302@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Eric Dumazet a écrit :
> > Vegard Nossum a écrit :
> >> 2009/6/7 John Dykstra <john.dykstra1@gmail.com>:
> >>> On Sat, 2009-05-30 at 22:23 +0200, Vegard Nossum wrote:
> >>>> It seems that loopback's hardware address is never initialized by the
> >>>> kernel. So if userspace attempts to read this address before it has
> >>>> been set, the kernel will return some uninitialized data (only 6
> >>>> bytes, though).
> >>> Thank you for the report, Vegard.
> >>>
> >>> I've been unable to reproduce the problem you describe, using
> >>> 2.6-30-rc8, this test program and a couple of kernel builds for system
> >>> load:
> >> [...]
> >>> ------------------------------------------------------------------
> >>>
> >>> Looking at the kernel code, it appears that all bytes of struct
> >>> net_device, including the L2 address, are initialized to zeros at
> >>> interface creation time.
> >>>
> >>> Can you spot a difference between your test procedures and mine that
> >>> would enable me to reproduce the problem?
> >> Hi,
> >>
> >> I just tried your test program on a linux-next kernel, it works beautifully :-)
> >>
> >> (I made one change: The stack grows downwards on x86, so I think you
> >> should put child_stack + 16386 as the stack to clone()?)
> >>
> >> As I wrote in reply to Stephen Hemminger, this problem seems to be
> >> caused by a particular patch in linux-next:
> >>
> >> commit f001fde5eadd915f4858d22ed70d7040f48767cf
> >> Author: Jiri Pirko <jpirko@redhat.com>
> >> Date:   Tue May 5 02:48:28 2009 +0000
> >>
> >>    net: introduce a list of device addresses dev_addr_list (v6)
> >>
> > 
> > I believe following patch should fix this problem.
> > 
> > Thank you
> > 
> > [PATCH net-next-2.6] net: loopback device dev->addr_len fix
> > 
> > commit f001fde5eadd915f4858d22ed70d7040f48767cf 
> > (net: introduce a list of device addresses dev_addr_list (v6))
> > added one regression Vegard Nossum found in its testings.
> > 
> > loopback device doesnt have a hw address, we should set its
> > dev->addr_len to 0, not ETH_ALEN.
> > 
> > Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Oh well, following is probably even more appropriate
> 
> [PATCH net-next-2.6] net: dev_addr_init() fix
> 
> commit f001fde5eadd915f4858d22ed70d7040f48767cf 
> (net: introduce a list of device addresses dev_addr_list (v6))
> added one regression Vegard Nossum found in its testings.
> 
> dev_addr_init() incorrectly uses sizeof() operator
> 
> Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Could you please put the word 'kmemcheck' somewhere into the 
changelog, to make git-grepping and historic comparisons easier?

Thanks,

	Ingo
