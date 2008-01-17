Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYAQILf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYAQILf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYAQIL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:11:26 -0500
Received: from imsa.nihilent.com ([203.124.131.74]:57972 "EHLO
	imsa.nihilent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYAQILZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:11:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Bitops source problem
Date: Thu, 17 Jan 2008 13:41:20 +0530
Message-ID: <1145971D427D7F43B0DBDAE22221C4B5035FDDAD@nipns00a210.FPS.NIHILENT.COM>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Bitops source problem
Thread-Index: AchY1JOW43XJXFe1SnSTACrNE0vx2QAAaRJQ
From: "Pravin Nanaware" <p.nanaware@nihilent.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "John Hubbard" <john.hubbard@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
X-TM-AS-Product-Ver: IMSS-7.0.0.1191-5.0.0.1023-15672.002
X-TM-AS-Result: No--11.507-7.0-31-1
X-imss-scan-details: No--11.507-7.0-31-1;No--11.507-7.0-31-1
X-TM-AS-User-Approved-Sender: No;No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, indeed none of the atomic bit operations functions has LOCK_PREFIX in my version of Linux kernel.

Regards,
Pravin


-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org]On Behalf Of Roland Dreier
Sent: Thursday, January 17, 2008 12:15 PM
To: Pravin Nanaware
Cc: John Hubbard; LKML
Subject: Re: Bitops source problem


 > Then, I think there is a problem with the function written below which is meant to be atomic.
 > 
 > static __inline__ void change_bit(int nr, volatile void * addr)
 > {
 >         __asm__ __volatile__(
 >                 "btcl %1,%0"
 >                 :"=m" (ADDR)
 >                 :"Ir" (nr));
 > }

If that is indeed the source of your change_bit function then there is
a problem.  However in my kernel tree there is a LOCK_PREFIX in the
definition of the atomic version.  I don't have your exact source tree
handy, but on a local RHEL4 system, the LOCK_PREFIX is still there:

static inline void change_bit(int nr, volatile unsigned long * addr)
{
        __asm__ __volatile__( LOCK_PREFIX
                "btcl %1,%0"
                :"=m" (ADDR)
                :"Ir" (nr));
}

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

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
