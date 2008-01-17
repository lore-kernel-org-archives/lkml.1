Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYAQGor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYAQGor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYAQGoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:44:39 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4507 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYAQGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:44:38 -0500
To: "Pravin Nanaware" <p.nanaware@nihilent.com>
Cc: "John Hubbard" <john.hubbard@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Bitops source problem
X-Message-Flag: Warning: May contain useful information
References: <1145971D427D7F43B0DBDAE22221C4B502CCE22D@nipns00a210.FPS.NIHILENT.COM>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 16 Jan 2008 22:44:35 -0800
In-Reply-To: <1145971D427D7F43B0DBDAE22221C4B502CCE22D@nipns00a210.FPS.NIHILENT.COM> (Pravin Nanaware's message of "Thu, 17 Jan 2008 12:08:19 +0530")
Message-ID: <adamyr5x86k.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jan 2008 06:44:36.0211 (UTC) FILETIME=[6CD29430:01C858D4]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
