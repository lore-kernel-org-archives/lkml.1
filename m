Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZBXIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZBXIkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZBXIk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:40:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbZBXIk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:40:26 -0500
Date: Tue, 24 Feb 2009 00:40:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tilman Schmidt <t.schmidt@phoenixsoftware.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [2.6.28.7] BUG: using smp_processor_id() in preemptible
 [00000000] code: pageattr-test/207
Message-Id: <20090224004001.fc2246da.akpm@linux-foundation.org>
In-Reply-To: <20090224083028.GA17355@elte.hu>
References: <49A2ECF5.80104@phoenixsoftware.de>
	<20090223151331.033e0bf5.akpm@linux-foundation.org>
	<49A343EE.20100@phoenixsoftware.de>
	<20090224083028.GA17355@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 09:30:28 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Tilman Schmidt <t.schmidt@phoenixsoftware.de> wrote:
> 
> > On Mon, 23 Feb 2009 15:13:31 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > A 2.6.28.6 -> 2.6.28.7 regressionlet.
> > > 
> > > This, I bet:
> > > 
> > > commit 2cf155b300c4839a7238b825c7c5f417e9d7cc68
> > > Author: Jeremy Fitzhardinge <jeremy@goop.org>
> > > Date:   Wed Feb 11 09:32:19 2009 -0800
> > > 
> > >     x86/cpa: make sure cpa is safe to call in lazy mmu mode
> > >     
> > >     commit 4f06b0436b2ddbd3b67b10e77098a6862787b3eb upstream.
> > 
> > Jackpot! Reverted that commit on 2.6.28.7, and the BUG messages are gone.
> 
> should be fixed by this as well:
> 
> d85cf93: x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption
> 

Yup, that patch got lost.

commit d85cf93da66977dbc645352be1b2084a659d8a0b
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Thu Feb 12 10:02:56 2009 -0800

    x86/paravirt: make arch_flush_lazy_mmu/cpu disable preemption

from Linus mainline is needed in 2.6.28.8, please.
