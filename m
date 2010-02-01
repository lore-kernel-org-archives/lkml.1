Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0BAKxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:53:30 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:49736 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0BAKx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:53:29 -0500
Subject: Re: debug: nt_conntrack and KVM crash
From: Jon Masters <jonathan@jonmasters.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <b6fcc0a1002010249y19e2edc3g7974f44633859bd3@mail.gmail.com>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265020552.7499.147.camel@tonnant>
	 <b6fcc0a1002010244j161f7f0bob46053efc0d65630@mail.gmail.com>
	 <b6fcc0a1002010247s70b855b6kea66c99c9326b6a@mail.gmail.com>
	 <b6fcc0a1002010249y19e2edc3g7974f44633859bd3@mail.gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 01 Feb 2010 05:53:19 -0500
Message-Id: <1265021599.7499.176.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 12:49 +0200, Alexey Dobriyan wrote:
> On Mon, Feb 1, 2010 at 12:47 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > Or even printk nf_conntrack_htable_size during bootup and panic/oops.
> 
> Oh, sorry, I see it was indeed corrupted.

Right. And it's not just the set size function that changes the value
(it wasn't in this case) so it's not sufficient to say that there is a
generic function to set the size. That only applies to the hashtable in
the global init_net anyway, changing the hashtable sizes and then
leaving the existing hashes as they were.

Additionally, the size is writeable in the module sysfs entry. So it's
not read only, even though I agree that the procfs visable entry is. I
really think this does need fixing, and I'm not just being a pain in the
ass - I have another issue here clearly with memory corruption, but the
need for this to be cleaned up is real.

Jon.


