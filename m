Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYAQGig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYAQGig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYAQGi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:38:26 -0500
Received: from imsa.nihilent.com ([203.124.131.74]:45239 "EHLO
	imsa.nihilent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYAQGi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:38:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Bitops source problem
Date: Thu, 17 Jan 2008 12:08:19 +0530
Message-ID: <1145971D427D7F43B0DBDAE22221C4B502CCE22D@nipns00a210.FPS.NIHILENT.COM>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Bitops source problem
Thread-Index: AchYzI8QM7KoW+7+QrWLm0hE2kWh1gABoAVA
From: "Pravin Nanaware" <p.nanaware@nihilent.com>
To: "John Hubbard" <john.hubbard@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
X-TM-AS-Product-Ver: IMSS-7.0.0.1191-5.0.0.1023-15672.002
X-TM-AS-Result: No--20.215-7.0-31-1
X-imss-scan-details: No--20.215-7.0-31-1;No--20.215-7.0-31-1
X-TM-AS-User-Approved-Sender: No;No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply John. 

Then, I think there is a problem with the function written below which is meant to be atomic.

static __inline__ void change_bit(int nr, volatile void * addr)
{
        __asm__ __volatile__(
                "btcl %1,%0"
                :"=m" (ADDR)
                :"Ir" (nr));
}

Regards,
Pravin


-----Original Message-----
From: John Hubbard [mailto:john.hubbard@gmail.com]
Sent: Thursday, January 17, 2008 11:17 AM
To: Pravin Nanaware
Cc: LKML
Subject: Re: Bitops source problem


Pravin Nanaware wrote:
> Hi,
> 
> I was just going through the include file in the /usr/include/asm/bitops.h
> 
> The function description describes it as non-atomic but it seems it is not. 
> 
> static __inline__ void __change_bit(int nr, volatile void * addr)
> {
>         __asm__ __volatile__(
>                 "btcl %1,%0"
>                 :"=m" (ADDR)
>                 :"Ir" (nr));
> }
> 
> The kernel version I am using is 2.6.9-42. Is it right or am I missing something ?  
> 
> Thanks,
> Pravin
> 

The bitops.h comments are correct: the btc IA-32 instruction is only 
atomic if used with the lock prefix. The function above does not use the 
lock prefix, so it is not atomic.

thanks,
John Hubbard


-**************Nihilent***************
" *** All information contained in this communication is confidential, proprietary, privileged
and is intended for the addressees only. If youhave received this E-mail in error please notify
mail administrator by telephone on +91-20-39846100 or E-mail the sender by replying to
this message, and then delete this E-mail and other copies of it from your computer system.
Any unauthorized dissemination,publication, transfer or use of the contents of this communication,
with or without modifications is punishable under the relevant law.

Nihilent has scanned this mail with current virus checking technologies. However, Nihilent makes no 
representations or warranties to the effect that this communication is virus-free.

Nihilent reserves the right to monitor all E-mail communications through its Corporate Network. *** "

*************************************************************************-
