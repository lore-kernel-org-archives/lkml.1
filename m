Return-Path: <linux-kernel-owner+w=401wt.eu-S1764567AbYEAXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764567AbYEAXaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYEAXal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:30:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:51393 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbYEAXak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,423,1204531200"; 
   d="scan'208";a="240794635"
Date: Thu, 1 May 2008 16:30:39 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Tom Rini <trini@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       torvalds@linux-foundation.org, bunk@kernel.org, davem@davemloft.net,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501233038.GA20601@linux-os.sc.intel.com>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com> <20080501154238.eccdb6ff.akpm@linux-foundation.org> <20080501232116.GD4354@smtp.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501232116.GD4354@smtp.west.cox.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:21:16PM -0700, Tom Rini wrote:
> On Thu, May 01, 2008 at 03:42:38PM -0700, Andrew Morton wrote:
> 
> [snip]
> > Is there some vaguely maintainable workaround we can do?  If the problem
> > only affects completely-empty weak functions then we could put something in
> > them to make them non-empty?
> 
> My memory is a tiny bit hazy (it was a while ago), but no, it's not just
> empty functions (again, I _think_ I hit it with a generic vs arch weak
> function).
> 

Other thing we observed was: this does not just depend on the __weak
function definition. It also depends on where the function is called from.

__weak function with single return statement, did not get inlined when called
from say

caller()
{
	function();
}

but got inlined when called as in

caller()
{
	for (;;) {
		function();
	}
}

Thanks,
Venki

