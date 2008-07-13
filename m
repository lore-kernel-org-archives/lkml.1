Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYGMS0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYGMS0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYGMS0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:26:13 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19181 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYGMS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:26:13 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
From: Andi Kleen <andi@firstfloor.org>
References: <200807080141.05436.yhlu.kernel@gmail.com>
	<200807080143.27997.yhlu.kernel@gmail.com>
	<200807092015.03004.yhlu.kernel@gmail.com>
	<20080710071640.5035cd70@infradead.org>
	<874p6t25n5.fsf@basil.nowhere.org>
	<20080713083322.16ebe80c@infradead.org>
Date: Sun, 13 Jul 2008 20:25:22 +0200
In-Reply-To: <20080713083322.16ebe80c@infradead.org> (Arjan van de Ven's message of "Sun, 13 Jul 2008 08:33:22 -0700")
Message-ID: <87myklzlnx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2008 18:17:56.0509 (UTC) FILETIME=[C60FCCD0:01C8E514]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> for the 2mb case.. please find me a dimm which isn't a multiple of
> 2Mb ;-)

DIMMs are not necessarily mapped continuously. Often they are mapped
"around" holes. Or some parts of the DIMM disappear magically for 
some hidden purpose like SMM. The actual DIMM sizes don't matter, but what
matters is what memory map the kernel sees after all translation
done in other layers.  And that end result is not necessarily
aligned to 2MB.
 
In that case pretty much all 64bit kernels will overmap slightly,
32bit kernels sometimes (e.g. under the right PAGE_OFFSET split
or when the <4GB hole is very large)

-Andi
