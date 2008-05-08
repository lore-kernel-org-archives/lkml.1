Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbYEHQs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbYEHQs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYEHQsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:48:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbYEHQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:48:46 -0400
Message-ID: <48232ECB.1060803@zytor.com>
Date: Thu, 08 May 2008 09:48:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com> <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de> <482311C9.2010603@keyaccess.nl> <alpine.LFD.1.10.0805081650440.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805081650440.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
>> The 'if this happens on the secondary CPU' sounds a bit like this is
>> directly checking the secondary CPU flag but cpu_has_pat translates into
>> boot_cpu_has(X86_FEATURE_PAT), refers always to the boot cpu.

No, it doesn't.  Although it is badly named, it refers to the common 
capability set of all online CPUs.

> Right and thats fine because of:
> 
>         /*
>          * On SMP, boot_cpu_data holds the common feature set between
>          * all CPUs; so make sure that we indicate which features are
>          * common between the CPUs.  The first time this routine gets
>          * executed, c == &boot_cpu_data.
>          */
>         if (c != &boot_cpu_data) {
>                 /* AND the already accumulated flags with these */
>                 for (i = 0 ; i < NCAPINTS ; i++)
>                         boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
>         }

... because of this code. :)

	-hpa
