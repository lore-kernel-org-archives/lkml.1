Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZHEXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZHEXKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZHEXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:10:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:30737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZHEXKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,331,1246863600"; 
   d="scan'208";a="436510211"
From: "Tan, Wei Chong" <wei.chong.tan@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 6 Aug 2009 07:10:00 +0800
Subject: RE: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Thread-Topic: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Thread-Index: AcoSGR9GWg3pVW2XQ2ei4n7v/JhgbAEB2KKw
Message-ID: <B28277FD4E0F9247A3D55704C440A140D5ADEC78@pgsmsx504.gar.corp.intel.com>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
 <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
 <20090731195705.GA12270@elte.hu>
In-Reply-To: <20090731195705.GA12270@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, we might want the error term to be even smaller, but 
> in no way does it actually invalidate any of the logic - 
> the 'tsc' reading is just a guess anyway. Also, I think 
> that the real issue isn't even an SMI - but the fact that 
> in the very last iteration of the loop, there's no 
> serializing instruction _after_ the last 'rdtsc'. So even 
> in the absense of SMI's, we do have a situation where the 
> cycle counter was read without proper serialization.
> 

Hi,

I just recall something which I cannot understand.  Earlier when we observed the wrong CPU frequency phenomenon (1666MHz being identified as 1800MHz), we use the same CPU and put them on 2 different boards.  On one board, the failure rate is high (about 1 out of every 20).  On the other, it almost never fails.
We compare the 2 boards and they are quite close to each other with one very prominent difference.  The failing board has no PS/2 port and so is using all USB keyboard/mouse while the good board uses PS/2 keyboard/mouse.
Thus, we plug in a USB keyboard on the good board and were then able produce the failure on the good board (despite at a lower failure rate, 1 out of every 100).
Does this not point to SMI?

Regards,
Wei Chong.
