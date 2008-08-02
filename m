Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYHBDLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYHBDLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYHBDLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:11:45 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:23698 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYHBDLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T0ahq8gBEc0wBKI8aDLbuqF+t7O5FbPD6X3uLMlWDyyTCHTbSfoyDpog86usOA5uts
         SK2WU5tP9RbiNL22ljjLT8CnxChCbQ67q6xoIsv25NfJzn44qMdXH3nZpwOt+BxZodP2
         LvLfyLK/oRbwfns4iRJ0Rv2o/43JQxx4UP0+A=
Message-ID: <86802c440808012011s109b27bbvb49e1794f66d9acc@mail.gmail.com>
Date: Fri, 1 Aug 2008 20:11:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: 64bit support more than 256 irq v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m14p64i0lr.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
	 <86802c440808011916q1a279ael995eaeaa655c239@mail.gmail.com>
	 <m14p64i0lr.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 7:58 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> On Fri, Aug 1, 2008 at 7:02 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> Dhaval Giani got:
>>> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
>>> invalid opcode: 0000 [1] SMP
>>> CPU 24
>>> ...
>>>
>>> his system (x3950) has 8 ioapic, irq > 256
..
>
> There was a patch that came out a while ago that set NR_IRQS as NR_IOAPICS*32 from
> SGI.  Where that got to I don't recall.

#ifdef CONFIG_X86_32
# define MAX_IO_APICS 64
#else
# define MAX_IO_APICS 128
# define MAX_LOCAL_APIC 32768
#endif

so they can take 128*32 = 4096?

YH
