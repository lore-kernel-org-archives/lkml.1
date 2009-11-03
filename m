Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZKCPwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZKCPwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZKCPwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:52:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZKCPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:52:10 -0500
Date: Tue, 3 Nov 2009 07:51:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
In-Reply-To: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.01.0911030748430.31845@localhost.localdomain>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Ian Campbell wrote:
> 
> Therefore calculating the sum of process_counts over only the online
> CPUs omits the processes which were started or stopped on any CPU which
> has since been unplugged. Only the sum of process_counts across all
> possible CPUs has meaning.

I think your patch is fine, but I also suspect that we could/should 
instead fix it by doing something like

	per_cpu(process_counts, this_cpu) += per_cpu(process_counts, down_cpu);
	per_cpu(process_counts, down_cpu) = 0;

in the CPU off-lining case after having quieted 'down_cpu'. That way we 
could always use online CPU's rather than possible CPU's. I think that 
just sounds nicer.

So I'll apply the patch, but I get the feeling it could be done better.

		Linus
