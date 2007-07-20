Return-Path: <linux-kernel-owner+w=401wt.eu-S938600AbXGTXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938600AbXGTXi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXGTXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:38:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541AbXGTXit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:38:49 -0400
Date: Fri, 20 Jul 2007 16:37:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?S=2E=C3=87a=C4=9Flar_Onur?= <caglar@pardus.org.tr>
cc: kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND] Late KVM Updates for the 2.6.23
 merge window
In-Reply-To: <200707210221.34121.caglar@pardus.org.tr>
Message-ID: <alpine.LFD.0.999.0707201633390.27249@woody.linux-foundation.org>
References: <1184952728548-git-send-email-avi@qumranet.com>
 <200707210221.34121.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Jul 2007, S.Çağlar Onur wrote:
> 
> With Linus's latest git, shutting down a guest (fired with -smp 2 -m 512) sometimes 
> ends up like [1], this occured as soon as qemu window closed.
> 
> [1] http://cekirdek.pardus.org.tr/~caglar/kvm/dmesg.latest

[  737.460654] Bad page state in process 'qemu-kvm'
[  737.460656] page:f5e68000 flags:0xea020000 mapping:00000000 mapcount:2 count:0
[  737.460657] Trying to fix it up, but a reboot is needed
[  737.460659] Backtrace:
[  737.460691]  [<c0159e70>] bad_page+0x64/0x8e
[  737.460733]  [<c015a7ee>] free_hot_cold_page+0x68/0x15a

That's the "free_pages_check()", and in particular it seems to be 
"page_mapcount()" being non-zero that triggered that thing.

So it looks like something in KVM isn't coherent about the mapping vs the 
usage counters..

		Linus
