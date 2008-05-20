Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYETLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYETLz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYETLzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:55:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYETLzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:55:18 -0400
Date: Tue, 20 May 2008 13:55:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Make LIST_POISON less deadly (v3)
Message-ID: <20080520115501.GA6045@elte.hu>
References: <1211283565-30671-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211283565-30671-1-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable 
> pointers in order to trap erronous use of freed list_heads.  
> Unfortunately userspace can arrange for those pointers to actually be 
> dereferencable, potentially turning an oops to an expolit.
> 
> To avoid this allow architectures (currently x86_64 only) to override 
> the default values for these pointers with truly-undereferncable 
> values. This is easy on x86_64 as the virtual address space is large 
> and contains unmapped ranges.

looks good - thanks Avi - i've added your patch to the -tip tree. I have 
opened a separate topic for it: tip/safe-poison-pointers. (because it 
affects other architectures as well)

	Ingo
