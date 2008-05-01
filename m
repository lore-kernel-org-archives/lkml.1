Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbYEAWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbYEAWvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbYEAWvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:51:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbYEAWvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:51:37 -0400
Date: Thu, 1 May 2008 18:49:56 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       torvalds@linux-foundation.org, bunk@kernel.org, davem@davemloft.net,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501224956.GM2255@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi> <20080501152051.4eb4bad3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org> <20080501223515.GA11366@linux-os.sc.intel.com> <20080501154238.eccdb6ff.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501154238.eccdb6ff.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:42:38PM -0700, Andrew Morton wrote:
> Is there some vaguely maintainable workaround we can do?  If the problem
> only affects completely-empty weak functions then we could put something in
> them to make them non-empty?

for (;;); isn't enough, the function would be still considered const and by
4.1.0 and some 4.1.1 incorrectly optimized out, without regard to weak
attribute.
But e.g.
asm ("");
should be enough.

	Jakub
