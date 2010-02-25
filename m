Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0BYQRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:17:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:54412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0BYQRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:17:49 -0500
Subject: Re: [PATCH 07/07] printk delay per multi lines
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hans-Joachim Picht <hans@de.ibm.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
In-Reply-To: <20100225154549.GA2710@darkstar>
References: <20100225154549.GA2710@darkstar>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 17:17:14 +0100
Message-ID: <1267114634.22519.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 23:45 +0800, Dave Young wrote:
> +               if (!atomic_read(&l))
> +                       atomic_set(&l, printk_delay_lines);

That's racy, use atomic_cmpxchg()

> +               smp_mb__before_atomic_dec();
> +               if (atomic_dec_return(&l))
> +                       return; 

What's that barrier for?

