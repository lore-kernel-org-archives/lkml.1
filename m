Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZJ2Ijd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZJ2Ijd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZJ2Ijc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZJ2Ijb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:39:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
Date: Thu, 29 Oct 2009 09:39:32 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
References: <4AE63E3D.8030903@us.ibm.com> <4AE63FA3.8040208@us.ibm.com>
In-Reply-To: <4AE63FA3.8040208@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910290939.32485.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18htcN2cInufXkWawAOy81DZrp+8bx5i4IsBZk
 34e/PvoprpYedIzFlNqPe4Zy0LCKdKsRDdqf4NJXjd0Tc4mJEe
 iX/kqtGLLSr5LzUl8v41g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009, Darren Hart wrote:
> The following C test case demonstrates how this patch could be used to
> implement interruptible locking. There is an awful lot of debug code and
> some other relics of a hacked together test in there now, but if anyone
> wanted to test the futex changes, this will do the trick.
> 

Your test program uses a signal handler to interrupt the mutex. If you
are using a signal handler already to implement a user space mutex_cancel,
why can't you just do a longjmp out of the signal handler rather than
modifying the kernel?

	Arnd <><
