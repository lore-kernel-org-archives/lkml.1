Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYG1Uqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYG1Uqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYG1Uqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:46:30 -0400
Received: from gw.goop.org ([64.81.55.164]:48281 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYG1Uq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:46:29 -0400
Message-ID: <488E3020.1040701@goop.org>
Date: Mon, 28 Jul 2008 13:46:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: righi.andrea@gmail.com, kosaki.motohiro@jp.fujitsu.com,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
References: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>	<488DF119.2000004@gmail.com>	<20080729012656.566F.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<488DFFB0.1090107@gmail.com> <20080728133030.8b29fa5a.akpm@linux-foundation.org>
In-Reply-To: <20080728133030.8b29fa5a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I can second that.  See
> http://userweb.kernel.org/~akpm/mmotm/broken-out/include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
>
> Ingo cruelly ignored it.  Probably he's used to ignoring the comit
> storm which I send in his direction - I'll need to resend it sometime.
>
> I'd consider that patch to be partial - we should demacroize the
> surrounding similar functions too.  But that will require a bit more
> testing.

Its immediate neighbours should be easy enough (pmd_alloc_one, 
__pmd_free_tlb), but any of the ones involving pmd_t risk #include hell 
(though the earlier references to pud_t in inline functions suggest it 
will work).  And pmd_addr_end is just ugly.

    J

