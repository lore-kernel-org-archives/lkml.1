Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZCLKIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZCLKIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbZCLKHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:07:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbZCLKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:07:52 -0400
Subject: Re: [PATCH 3/6] futex: add double_unlock_hb()
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20090312075552.9856.48021.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
	 <20090312075552.9856.48021.stgit@Aeon>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:07:35 +0100
Message-Id: <1236852455.5090.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 00:55 -0700, Darren Hart wrote:
> The futex code uses double_lock_hb() which locks the hb->lock's in pointer
> value order.  There is no parallel unlock routine, and the code unlocks them
> in name order, ignoring pointer value.  This opens up a window for an ABBA
> deadlock.  This patch adds double_unlock_hb() to remove the window as well
> as refactor the duplicated code segments.

While I don't mind the patch per-se, I'm hard pressed to see any
deadlock potential in the unordered unlock.

All sites (at least those in the patch) always release both locks
without taking another in between, therefore one would think there's no
deadlock possible.


