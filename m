Return-Path: <linux-kernel-owner+w=401wt.eu-S1422801AbXBPANu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422801AbXBPANu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422806AbXBPANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:13:49 -0500
Received: from gw.goop.org ([64.81.55.164]:59661 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbXBPANt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:13:49 -0500
Message-ID: <45D4F735.1020106@goop.org>
Date: Thu, 15 Feb 2007 16:13:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize generic get_unaligned / put_unaligned implementations.
References: <20050830104056.GA4710@linux-mips.org>	<20060306.203218.69025300.nemoto@toshiba-tops.co.jp>	<20060306170552.0aab29c5.akpm@osdl.org>	<20070214214226.GA17899@linux-mips.org>	<20070214203903.8d013170.akpm@linux-foundation.org>	<20070215143441.GA18155@linux-mips.org>	<20070215135358.020781dd.akpm@linux-foundation.org>	<20070215221839.GA14103@linux-mips.org> <20070215153823.239fd616.akpm@linux-foundation.org>
In-Reply-To: <20070215153823.239fd616.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> hm.  So if I have
>
> 	struct bar {
> 		unsigned long b;
> 	} __attribute__((packed));
>
> 	struct foo {
> 		unsigned long u;
> 		struct bar b;
> 	};
>
> then the compiler can see that foo.b.b is well-aligned, regardless of the
> packedness.

In Ralf's code, the structure is anonymous, and is used to declare a
pointer type, which is initialized from a void *.  So I think the
compiler isn't allowed to assume anything about its alignment.

    J
