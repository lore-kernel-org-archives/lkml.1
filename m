Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbYFMHYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbYFMHYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYFMHYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:24:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:23442 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYFMHYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,637,1204531200"; 
   d="scan'208";a="292510611"
Subject: Re: [BUGFIX] lockdep: output lock_class key instead of address for
	forward dependency output
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20080613065809.GA28810@elte.hu>
References: <1213339217.17201.6.camel@caritas-dev.intel.com>
	 <20080613065809.GA28810@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 15:26:05 +0800
Message-Id: <1213341965.17201.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 13 Jun 2008 07:24:04.0609 (UTC) FILETIME=[75A26F10:01C8CD26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-13 at 08:58 +0200, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > The key instead of address of lock_class should be output in
> > /proc/lockdep when forward dependency is output, because key is
> > output for lock_class itself as identifier too.
> > 
> > This patch is based on x86/auto-latest branch of git-x86 tree, and has
> > been tested on x86_64 platform.
> 
> applied to tip/core/locking - thanks Ying.
> 
> i'm wondering, can entry->class never be NULL here?

As far as I know, it can never be NULL. Because entry is added into
class->locks_after in following call chain:

lock_acquire -> __lock_acquire -> validate_chain -> check_prevs_add ->
check_prev_add -> add_lock_to_list

in __lock_acquire the lock_class is look up or registered from
lockdep_map and put in held_lock, which is used in following function in
call chain.

Best Regards,
Huang Ying

