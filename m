Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbXGRAkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbXGRAkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbXGRAk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:40:28 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:14467 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbXGRAk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=RMZn1AIMPni4GC4RUA4doHY9UJz2m8G7TGCNBRN637vDljStCnRoscPrzrBSy+WP8kYAiK3cYHY3Vn2U6gyki7010XvJ5/s/4IeI1gbzaFEHxPkkTw96Q1ZT0drv3mTdeHRvOT4viEEGJGAxVp8/WAe627etm5/X7dFzQ10DhI0=
Message-ID: <469D6135.4000301@googlemail.com>
Date: Wed, 18 Jul 2007 02:39:17 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com
Subject: Re: [PATCH 0/2] SELinux Netlabel updates
References: <Line.LNX.4.64.0707171945430.10858@d.namei> <alpine.LFD.0.999.0707171719320.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171719320.27353@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds pisze:
> 
> On Tue, 17 Jul 2007, James Morris wrote:
>> These are updated Netlabel/SELinux changes from Paul, reworked so that 
>> they don't break userspace.  Michal says they work for him.  Please apply 
>> for 2.6.23.
> 
> They don't work AT ALL for me:
> 
> 	security/selinux/ss/sidtab.o: In function `netlbl_enabled':
> 	sidtab.c:(.text+0x0): multiple definition of `netlbl_enabled'
> 	security/selinux/ss/ebitmap.o:ebitmap.c:(.text+0x0): first defined here
> 
> Tssk.

Once again I tested both patches, build log shows only this

Root device is (8, 1)
Setup is 10264 bytes (padded to 10752 bytes).
System is 2040 kB
WARNING: vmlinux(.text+0xc1001183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc126dafb): Section mismatch: reference to .init.text: (between 'rest_init' and 'kthreadd_setup')
WARNING: vmlinux(.text+0xc1271a3b): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1271a48): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1271a54): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1271a60): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc126dc11): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_
map' and 'zone_wait_table_init')
WARNING: vmlinux(.text+0xc126dc9b): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table
_init' and '__sched_text_start')
WARNING: vmlinux(.text+0xc1272252): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')

gcc --version
gcc (GCC) 4.1.2 20070502 (Red Hat 4.1.2-12)

> 
> That dummy "netlbl_enabled()" should be "static inline", methinks.
> 
> Also, that <net/netlabel.h> file has two blocks after each other of
> 
> 	#ifdef CONFIG_NETLABEL
> 	..
> 	#else
> 	..
> 	#endif
> 
> 	#ifdef CONFIG_NETLABEL
> 	..
> 	#else
> 	..
> 	#endif
> 
> which might as well be cleaned up at the same time (and might have avoided 
> this bug, since then the people involved would have seen the _correct_ 
> example in the first version)
> 
> Please fix up and ask me to pull again. Preferably by actually fixing up 
> the commit itself, so that we don't unnecessarily have revisions that 
> don't even compile and thus potentially screw up git-bisect attempts.
> 
> 			Linus
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
