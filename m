Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268Ab0AZIeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0AZIeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112Ab0AZId6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:33:58 -0500
Received: from www.tglx.de ([62.245.132.106]:50165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab0AZId5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:33:57 -0500
Date: Tue, 26 Jan 2010 09:33:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Mark Seaborn <mrs@mythic-beasts.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>
Subject: Re: futex() on vdso makes process unkillable
In-Reply-To: <20100126113312.5AA3.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1001260931490.5926@localhost.localdomain>
References: <1264411574.4283.1632.camel@laptop> <4B5DD6DF.4090102@us.ibm.com> <20100126113312.5AA3.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010, KOSAKI Motohiro wrote:
> > Peter Zijlstra wrote:
> > I like the creating-a-real-file solution. However, for now (and for 
> > stable), I think Kosaki's suggestion of EINVAL or EFAULT is a good 
> > stop-gap. EINVAL might play the best with existing glibc implementations.
> 
> May I confirm your mention?
> 
> If we can accept EFAULT, we don't need any change. my previous futex patch
> already did. because 1) VDSO is alwasys read-only mapped 2) write mode
> get_user_pages_fast() against read-only pte/vma return EFAULT.
> 
> Current linus and stable tree don't cause Mark's original problem. instead, just
> return EFAULT. (Well, I'm sorry. my previous mail was unclear. I wrote v2.6.31 test
> result)
> 
> If you can't accept EFAULT, we need to add vdso specific logic into get_futex_key().

EFAULT is perfectly fine. No need for any special tricks.

Thanks,

	tglx

