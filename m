Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbXJVKAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbXJVKAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXJVJ77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:59:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:24954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbXJVJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=MDOudF4hKmvWSYk6e2HzS000HGoRLCH4gE/dJdZW334crmGbjeClSru01//lnwuJR9HRD2f+Q7eMvp+giJIChrkRwYSt+NY36LEquD9yaPvXzFs6ba/A8L+V2M/4ADUD9yP6Pbi/flK01MXDIJzYTqC2k5N6OTgktTPpn/9a6xc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 100% iowait on one of cpus in current -git
Date: Mon, 22 Oct 2007 11:59:19 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710220822.52370.maximlevitsky@gmail.com> <1193046118.27435.166.camel@twins>
In-Reply-To: <1193046118.27435.166.camel@twins>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200710221159.19364.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 11:41:57 Peter Zijlstra wrote:
> On Mon, 2007-10-22 at 08:22 +0200, Maxim Levitsky wrote:
> > Hi,
> > 
> > I found a bug in current -git:
> > 
> > On my system on of cpus stays 100% in iowait mode (I have core 2 duo)
> > Otherwise the system works OK, no disk activity and/or slowdown.
> > Suspecting that this is a swap-related problem I tried to turn swap of, but it doesn't affect anything.
> > It is probably some accounting bug.
> > 
> > If I start with init=/bin/bash, then this disappears.
> > I tried then to start usual /etc/init.d scripts then, and first one to show this bug was gpm.
> > but then I rebooted the system to X without gpm, and I still see 100% iowait.
> > 
> > No additional messages in dmesg.
> 
> does sysrq-t show any D state tasks?
> 
> 
This one:
Probably per-block device dirty writeback?
I am compiling now revision 1f7d6668c29b1dfa307a44844f9bb38356fc989b
Thanks for the pointer.



[  673.365631] pdflush       D c21bdecc     0   221      2
[  673.365635]        c21bdee0 00000046 00000002 c21bdecc c21bdec4 00000000 c21b3000 00000002
[  673.365643]        c0134892 c21b3164 c1e00200 00000001 c7109280 c21bdec0 c03ff849 c21bdef0
[  673.365650]        00052974 00000000 000000ff 00000000 00000000 00000000 c21bdef0 000529dc
[  673.365657] Call Trace:
[  673.365659]  [<c03fd728>] schedule_timeout+0x48/0xc0
[  673.365663]  [<c03fd50e>] io_schedule_timeout+0x5e/0xb0
[  673.365667]  [<c0170d11>] congestion_wait+0x71/0x90
[  673.365671]  [<c016b92e>] wb_kupdate+0x9e/0xf0
[  673.365675]  [<c016beb2>] pdflush+0x102/0x1d0
[  673.365679]  [<c013fa82>] kthread+0x42/0x70
[  673.365683]  [<c01050df>] kernel_thread_helper+0x7/0x18


Best regards,
	Maxim Levitsky
