Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYHSGim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYHSGim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYHSGid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:38:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYHSGid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:38:33 -0400
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [patch]pageattr: cache flush before tlb flush
From: Andi Kleen <andi@firstfloor.org>
References: <1219026451.16428.4.camel@sli10-desk.sh.intel.com>
Date: Tue, 19 Aug 2008 08:38:28 +0200
In-Reply-To: <1219026451.16428.4.camel@sli10-desk.sh.intel.com> (Shaohua Li's message of "Mon, 18 Aug 2008 10:27:31 +0800")
Message-ID: <877iad1pcr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> clflush uses a virtual address but cache line is physical indexed in
> x86. In my understanding, clflush will do some pagetable walk, so doing
> cache flush first should reduce some pagetable walk.

The SDM describes the exact sequence how this should be done.
Linux unfortunately skips one step currently, but it's not a good
idea to diverge even more.

-Andi
