Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYAQG7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYAQG7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYAQG7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:59:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50882 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYAQG7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:59:23 -0500
Date: Thu, 17 Jan 2008 15:59:24 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: Bitops source problem
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Pravin Nanaware" <p.nanaware@nihilent.com>,
       "John Hubbard" <john.hubbard@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
In-Reply-To: <adamyr5x86k.fsf@cisco.com>
References: <1145971D427D7F43B0DBDAE22221C4B502CCE22D@nipns00a210.FPS.NIHILENT.COM> <adamyr5x86k.fsf@cisco.com>
Message-Id: <20080117155723.11DC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> If that is indeed the source of your change_bit function then there is
> a problem.  However in my kernel tree there is a LOCK_PREFIX in the
> definition of the atomic version.  I don't have your exact source tree
> handy, but on a local RHEL4 system, the LOCK_PREFIX is still there:
> 
> static inline void change_bit(int nr, volatile unsigned long * addr)
> {
>         __asm__ __volatile__( LOCK_PREFIX
>                 "btcl %1,%0"
>                 :"=m" (ADDR)
>                 :"Ir" (nr));
> }

2.6.24-rc6-mm1 have LOCK_PREFIX too :)


static inline void change_bit(int nr, volatile void *addr)
{
        asm volatile(LOCK_PREFIX "btc %1,%0"
                     : ADDR : "Ir" (nr));
}

