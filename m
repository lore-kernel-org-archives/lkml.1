Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYIHTwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYIHTwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYIHTwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:52:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbYIHTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:52:00 -0400
Date: Mon, 08 Sep 2008 12:51:53 -0700 (PDT)
Message-Id: <20080908.125153.263452187.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: travis@sgi.com, mingo@elte.hu, akpm@linux-foundation.org, steiner@sgi.com,
       jes@sgi.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smp: reduce stack requirements for
 smp_call_function_mask
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809082030.41987.nickpiggin@yahoo.com.au>
References: <20080906132944.GC4910@elte.hu>
	<48C2C810.3070809@sgi.com>
	<200809082030.41987.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Mon, 8 Sep 2008 20:30:41 +1000

> Is that being tried? Setting it to 8192 or even higher during QA seems
> like a good idea to me.

This is a great idea, especially since it will make it even more
painfully obvious that essentially any function local cpumask_t
variable is a bug.

Really, it seems sensible to do something like:

1) Make cpumask_t a pointer.

2) Add cpumask_data_t which is what cpumask_t is now.  This gets
   used when for the actual storage, and will only get applied to
   datastructures that are dynamically allocated.  For example, for
   the cpu_vm_mask in mm_struct.

3) Type make and fix build failures until they are all gone.
