Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYBQGki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYBQGki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYBQGk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:40:29 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53671 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYBQGk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:40:28 -0500
Date: Sat, 16 Feb 2008 22:39:04 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080217063904.GE26206@mail.oracle.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Ian Campbell <ijc@hellion.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com> <47B64E0A.1020007@goop.org> <20080216085454.GA24570@ca-server1.us.oracle.com> <47B6CD0F.4020202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B6CD0F.4020202@goop.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 10:46:23PM +1100, Jeremy Fitzhardinge wrote:
>>> What does this EIP correspond to in your kernel?  Also:
>>>
>>> c01687f0 c0417ab6 c040288f c040299a c0403270
>>>
>>> (as guesses of potential callers to try and work out a stack trace).
>>>     
>>
> (My usual technique is use "gdb vmlinux" and "x/i 0x...." to do the  
> lookup.) 

	Ok, my objdump didn't do a good job.  With gdb I get:

0xc04040bd <xen_set_pte_at+185>:	mov    %edi,(%eax)
0xc01687f0:	Cannot access memory at address 0xc01687f0
0xc0417ab6 <__set_fixmap+326>:	pop    %ecx
0xc040288f <xen_alloc_ptpage+41>:	lock btsl $0x8,(%eax)
0xc040299a <xen_load_idt+74>:	lock incb 0xc0766148
0xc0403270 <xen_set_pte_atomic+26>:	lock cmpxchg8b (%edi)

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
