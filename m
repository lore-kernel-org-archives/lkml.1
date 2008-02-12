Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYBLAgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYBLAgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYBLAgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:36:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYBLAgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:36:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Priit Laes <plaes@plaes.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: REGRESSION: x86 vDSO: remove vdso-syms.o
In-Reply-To: Priit Laes's message of  Tuesday, 12 February 2008 02:00:05 +0200 <1202774405.23992.9.camel@localhost>
References: <1202769045.10829.12.camel@localhost>
	<20080211225332.2AE2E270191@magilla.localdomain>
	<1202774405.23992.9.camel@localhost>
X-Zippy-Says: I'm young..  I'm HEALTHY..  I can HIKE THRU CAPT GROGAN'S LUMBAR REGIONS!
Message-Id: <20080212003631.BF1D8270191@magilla.localdomain>
Date: Mon, 11 Feb 2008 16:36:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not see it with your .config either.

> This fails with clean build. And vdso-syms.lds is not empty.
> 
> Contents of ?arch/x86/vdso/vdso-syms.lds:
> VDSO64_PRELINK = 0xffffffffff700000;
> VDSO64_jiffies = 0xffffffffff7004b8;

Odd.  The missing symbols come from the same place that VDSO64_jiffies did.
The end of the arch/x86/vdso/vdso.lds file in your build should have these:

VDSO64_jiffies = vdso_jiffies;
VDSO64_vgetcpu_mode = vdso_vgetcpu_mode;
VDSO64_vsyscall_gtod_data = vdso_vsyscall_gtod_data;

readelf -s arch/x86/vdso/vvar.o in your build should show (among others):

     8: 0000000000000000     8 OBJECT  GLOBAL DEFAULT    4 vdso_jiffies
     9: 0000000000000008     8 OBJECT  GLOBAL DEFAULT    4 vdso_vgetcpu_mode
    10: 0000000000000010     8 OBJECT  GLOBAL DEFAULT    4 vdso_vsyscall_gtod_data

If either of those is not all there, you'll have to look into what's
happening in the generation of the respective files.


Thanks,
Roland
