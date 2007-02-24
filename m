Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbXBXWp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbXBXWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbXBXWp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:45:56 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:7085 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbXBXWpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:45:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IKJBPUdzCYF7h1zVW0InoJrZwcXgiiCe5kwpGxriKg1t37g0mZcZuy2GxHYg1QrPJ6rZJsEAmm+cRhs/DxurIV8sN1rc3oPz4gYnBd3d/VhwwK8JEvhnjHtaUkYRRtoe7oDHvgyIyEpDMLOvTcWOrLpde9401G1Koh53DdyDb10=
Message-ID: <6bffcb0e0702241445v562be44y5ddac6d6abdb5131@mail.gmail.com>
Date: Sat, 24 Feb 2007 23:45:54 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@googlemail.com>,
       tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070223060802.GA8562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
	 <1172072023.25076.64.camel@localhost.localdomain>
	 <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
	 <1172088044.25076.125.camel@localhost.localdomain>
	 <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com>
	 <20070223060802.GA8562@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 23/02/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> Michal,
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Here is more
> >
> > hardirqs last  enabled at (30787): [<c0104249>] syscall_exit_work+0x11/0x26
> > hardirqs last disabled at (30788): [<c0103fc9>] ret_from_exception+0x9/0xc
> > softirqs last  enabled at (30202): [<c01265df>] __do_softirq+0xe4/0xea
> > softirqs last disabled at (30193): [<c0106a75>] do_softirq+0x64/0xd1
>
> could you please try the patch below? This is pretty much the only
> condition under which we can silently 'leak' pending softirqs, and
> trigger the new warning: if something does cond_resched_softirq() in
> non-runnable state. (which is a no-no, but nothing enforced this, so it
> could in theory happen.) So the question is, with this patch applied, do
> you get these new warnings from sched.c?

Here is a dmesg after over 25 hours of uptime
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc1/git-dmesg3
nothing new.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
