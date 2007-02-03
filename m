Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbXBCWcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbXBCWcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXBCWcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:32:42 -0500
Received: from 1wt.eu ([62.212.114.60]:2238 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbXBCWcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:32:41 -0500
Date: Sat, 3 Feb 2007 23:32:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: flow control off
Message-ID: <20070203223231.GG24090@1wt.eu>
References: <20070202153425.2d979fd4@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202153425.2d979fd4@freekitty>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Feb 02, 2007 at 03:34:25PM -0800, Stephen Hemminger wrote:
> Turn flow control off for sky2. When flow control is on, the transmitter
> may get randomly stuck. Perhaps there is hardware problem, but until
> Marvell provides errata information for workaround, it should default to off.

Are you aware of any way to reproduce or at least to increases chances
of occurrences of this problem ? It looks much like a problem I've been
experiencing with Marvell's driver with a 88E8053 chip on 2.4. Doing
"ethtool -r" proved useful to reset the transceiver in production.

When trying to reproduce the problem, I noticed corrupted and duplicated
frames in tcpdump captures when packets between 147 and 496 bytes were
received then re-routed via the same NIC towards a 100 Mbps machine on
the same switch, a Gig Dlink doing flow control. Yes, I know, there are
a lot of variables ! But changing the target machine, or the packet
sizes was enough to stop the corruption. I could not get the transmitter
stuck as I sometimes have in production, but I think that both problems
are related. The fact that a comparable problem is encountered with your
driver really makes me think about a hardware bug :-/

BTW, switching to your driver (sky2-1.5), I could not reproduce the
corruption problem anymore, but I've not yet put it in production
to check if it fixes the transceiver problem. Anyway, it might be
interesting that users who encounter this problem try an old version
of the driver just in case they detect a difference.

regards,
Willy

