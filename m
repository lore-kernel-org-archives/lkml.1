Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZG3RV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZG3RV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZG3RV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:21:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZG3RVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:21:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: eranian@gmail.com
Subject: Re: I.1 - System calls - ioctl
Date: Thu, 30 Jul 2009 19:20:52 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       "perfmon2-devel" <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <200907301840.50894.arnd@arndb.de> <7c86c4470907300953g255c6088t7caaa1188be164e3@mail.gmail.com>
In-Reply-To: <7c86c4470907300953g255c6088t7caaa1188be164e3@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907301920.52257.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+P9ZOq2dJCaibttFW8Eh2S8r72nRkOYzbzJ+e
 Nh8mI1eLEbW451npXXC4K2tbRx9ph/LUmFjhzNUV4jcpKzILHZ
 DKNKZT706k05m/s0Krumw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, stephane eranian wrote:
> But that won't always work in the case of a 32-bit monitoring tool
> running on top of
> a 64-bit OS. Imagine the target id is indeed 64-bit, e.g., inode
> number (as suggested
> by Peter). It's not because you are a 32-bit tool than you cannot name
> a monitoring
> resource in a 64-bit OS.

Right, there are obviously things that you cannot address with 
a 'long', but there are potentially other things that you could
that you cannot address with an 'int', e.g. an opaque user
token (representing a user pointer) that you can get back in
the sample data.

In the worst case, you could still redefine the argument as a
transparent union to a long and pointer in the future if you
use a 'long' now. AFAICT, there are no advantages of using
an 'int' instead of a 'long', but there are disadvantages of
using a 'long long'.

	Arnd <><
