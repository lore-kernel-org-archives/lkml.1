Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZI3Rqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZI3Rqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZI3Rqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:46:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54099 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZI3Rqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:46:48 -0400
Date: Wed, 30 Sep 2009 18:46:44 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] checkpatch: fix false EXPORT_SYMBOL warning
Message-ID: <20090930174644.GG2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-5-git-send-email-dwalker@fifo99.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253585691-10987-5-git-send-email-dwalker@fifo99.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 07:14:51PM -0700, Daniel Walker wrote:
> Ingo reported that the following lines triggered a false warning,
> 
> static struct lock_class_key rcu_lock_key;
> struct lockdep_map rcu_lock_map =
>         STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
> EXPORT_SYMBOL_GPL(rcu_lock_map);
> 
> from kernel/rcutree.c , and the false warning looked like this,
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its
> function/variable
> +EXPORT_SYMBOL_GPL(rcu_lock_map);
> 
> This change corrects this. It was caused because checkpatch doesn't check
> more than one line above the "EXPORT_SYMBOL" for additional context (ie.
> variable name, or initializer). Things are somewhat more complicated
> because STATIC_LOCKDEP_MAP_INIT() doesn't accept the variable name that
> is being initialized. I just added another check that checks two lines
> above "EXPORT_SYMBOL" for the variable declaration.

In theory the thing we are exporting can be an arbitrary number of lines
prior to the EXPORT_SYMBOL statement.  We actually want to look at the
statement before the EXPORT_*. 

I had a go at doing it this way and it seems to work on my test sets.
Perhaps you could test the version at the url below:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

NOTE: you want at least version 0.29-5-* which is in the process of 
mirroring out.

-apw
