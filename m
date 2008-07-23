Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGWUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGWUbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYGWUbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:31:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:36050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbYGWUbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:31:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,239,1215414000"; 
   d="scan'208";a="421366356"
Date: Wed, 23 Jul 2008 13:31:09 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Message-ID: <20080723203109.GH14380@linux-os.sc.intel.com>
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
> Hi,
> 
> I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
> yesterday):

Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
changes.

> 
> BUG: unable to handle kernel paging request at 00664381
> IP: [<c010b274>] free_thread_xstate+0x4/0x30
...

> EIP is at arch/x86/kernel/process.c:36:
> 
>         if (tsk->thread.xstate) {
> 

It looks like the kernel stack of that process got corrupted, corrupting the
task pointer in thread_info. Can you send us your config file?

thanks,
suresh
