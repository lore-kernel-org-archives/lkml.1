Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0AOIiH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578Ab0AOIiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:38:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56692 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0AOIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:38:05 -0500
Date: Fri, 15 Jan 2010 00:36:42 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Ian Campbell <ijc@hellion.org.uk>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
In-Reply-To: <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
Message-ID: <alpine.DEB.2.01.1001150011480.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de>  <4B4405B5.9040205@goop.org>  <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>  <20100106112133.GA5815@lenovo>  <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> 
 <4B4633D3.2070903@zytor.com>  <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>  <20100108215039.GD4967@lenovo>  <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>  <20100110080940.GB5189@lenovo>
 <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+l5L1kRsS+3DRVMkLOIP/Djm/MeKXAfRwleQo
 eWAs1b8EeSwHHB/Xj8v2jQscTCaH/fzp0vvOiu2CqnbNNpy9jZ
 PedwU5xeynAq6pn2LBzXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 at 12:59, Ian Campbell wrote:
> The correct fix is for the Xen backend to declare kernel RPL == 0 for 64
> bit guests -- the hyervisor already takes care of all the necessary
> squashing to ring 3 transparently (because making the guest worry about
> it would break the very common assumption that you can distinguish user
> from kernel CS by RPL).

Yes' it's a 64bit guest, I should have mentioned this from the beginning. 
With the 2 patches from Ian and Cyrill applied, the DomU is now booting 
fine again (currently running mainline -git).

Cyrill: with your patch alone (for arch/x86/kernel/process.c), the DomU
is still not booting, Dom0 "xm dmesg" reporting the same error. As it's
working with both patches applied, should I try to test with only Ian's
patch (for arch/x86/xen/enlighten.c) applied?

In any case, feel free to add:

   Tested-by: Christian Kujau <lists@nerdbynature.de>

Thanks so much for your efforts to everyone involved!

Christian.
-- 
BOFH excuse #436:

Daemon escaped from pentagram
