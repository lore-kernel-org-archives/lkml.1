Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbZFLSH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbZFLSH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZFLSHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:07:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34464 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755025AbZFLSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:07:50 -0400
Date: Fri, 12 Jun 2009 19:07:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when
 feature is disabled
Message-ID: <20090612190732.3e5b6955@lxorguk.ukuu.org.uk>
In-Reply-To: <20090612161431.GB5680@localhost>
References: <20090611142239.192891591@intel.com>
	<20090611144430.414445947@intel.com>
	<20090612112258.GA14123@elte.hu>
	<20090612125741.GA6140@localhost>
	<20090612131754.GA32105@elte.hu>
	<20090612133352.GC6751@localhost>
	<20090612153620.GB23483@elte.hu>
	<20090612161431.GB5680@localhost>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> HWPOISON is a reliability enabling feature - if it enables prevalent
> of crappy hardwares, let's celebrate changing the world~~

HWPOISON is not in the most part a reliability enabling feature. Nothing
of the sort.

The existing behaviour is that your system goes kerblam on such a serious
error. The replacement behaviour is that bits of your machine go kerblam
in unpredictable ways.

In both cases you actually improve your reliability with clustering and
failover.

There are a few special cases its potentially useful - lots of VMs being
one where you have some chance of a controlled failure of a bounded
system. But even in that case I know if I was admin my scripts would read

   if (hwpoison_error)
        migrate_all_guests()
        mail admin
        schedule replacement of the machine

I'm not actually sure teaching hwpoison to handle anything but losing
entire guest OS systems is useful.
