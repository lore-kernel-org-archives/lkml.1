Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZF1VtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZF1VtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZF1Vsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:48:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45646 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZF1Vsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:48:53 -0400
Date: Sun, 28 Jun 2009 23:48:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
Message-ID: <20090628214855.GC6760@one.firstfloor.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626104804.GA7337@hmsreliant.think-freely.org> <20090626092001.32e35e17.akpm@linux-foundation.org> <20090628193112.GA6760@one.firstfloor.org> <20090628135235.10f9b153.akpm@linux-foundation.org> <m163egt524.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163egt524.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrew should I toss all 100 or so patches over the wall to you
> and your -mm tree?  Or should I maintain a public git tree based
> at 2.6.31-rc1?  Get it into linux-next and ask Linus to pull it when
> the merge window comes?

What do these 100 odd patches do exactly? 

I think DEFINE_SYSCTL()/ELF section would be the correct direction to go
for all global variable sysctls.

Then the binary sysctls could be handled by a global table
in a separate file like you described

[My old patch back then also had a sysctl_name() syscall to still
allow changing sysctl without mounting /proc, but that wasn't 
very popular]

For dynamically generated sysctls (relatively rare but there) 
the current interfaces are not great, but could be probably kept.

That all doesn't really need 100 patches though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
