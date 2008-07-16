Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbYGPSyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbYGPSyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYGPSyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:54:31 -0400
Received: from gw.goop.org ([64.81.55.164]:55492 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYGPSya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:54:30 -0400
Message-ID: <487E43D9.7080703@goop.org>
Date: Wed, 16 Jul 2008 11:54:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Large increase in context switch rate
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

We have Alex Nixon doing some profiling of Xen kernels, comparing 
current pvops Xen and native with the last "official" Xen kernel 
2.6.18.8-xen.

One obvious difference is that the kernbench context switch rate is way 
up, from about 30k to 110k.  Also, the user time went up from about 375s 
to 390s - and that's comparing pvops native to 2.6.18.8-xen (pvops Xen 
was more or less identical).

I wonder if the user time increase is related to the context switch 
rate, because the actual context switch time itself is accounted to the 
process, or because of secondary things like cache and tlb misses.  Or 
perhaps the new scheduler accounts for things differently?

Anyway, I'm wondering:

    * is the increased context switch rate expected?
    * what tunables are there so we can try and make them have
      comparable context switch rates?

This is an issue because the Xen/pvops kernel is showing a fairly large 
overall performance regression, and the context switches a specifically 
slow compared to the old Xen kernel, and the high switch rate is 
presumably compounding the problem.  It would be nice to have some knobs 
to turn to see what the underlying performance characteristics are.

Thanks,
    J
