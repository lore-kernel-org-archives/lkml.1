Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYGMO6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYGMO6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 10:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYGMO5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 10:57:55 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:64856 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYGMO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 10:57:55 -0400
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
Date: Sun, 13 Jul 2008 16:57:50 +0200
In-Reply-To: <20080710071640.5035cd70@infradead.org> (Arjan van de Ven's message of "Thu, 10 Jul 2008 07:16:40 -0700")
Message-ID: <874p6t25n5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2008 14:50:23.0798 (UTC) FILETIME=[C7AAE560:01C8E4F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Wed, 9 Jul 2008 20:15:02 -0700
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> 
>> 
>> fix phys_pmd_init to make sure not to return big value than end.
>> 
>> also print out range split:1G/2M/4K
>> 
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>
> Making an accurate mapping solves a lot of potentially nasty/tricky
> corner cases, so I like the approach

It also means that e.g. on a 1GB system the direct mapping will 
never use 1GB pages.

And the CPU has to handle this anyways because all the old 
kernels overmap and no x86 CPU can drop support for all old
kernels.

In the end it means only large systems will benefit from 1GB
pages, which seems wrong to me.

-Andi
