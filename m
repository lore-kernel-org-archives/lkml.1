Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZKLPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZKLPTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZKLPTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:19:17 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:45973 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZKLPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:19:17 -0500
Date: Thu, 12 Nov 2009 10:16:48 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: percpu tree build warning
In-Reply-To: <20091112174558.128cea97.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.1.10.0911121016170.28271@V090114053VZO-1>
References: <20091112174558.128cea97.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Stephen Rothwell wrote:

> Hi all,
>
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
>
> drivers/net/loopback.c: In function 'loopback_get_stats':
> drivers/net/loopback.c:109: warning: initialization discards qualifiers from pointer target type
>
> The line in question is:
>
> 	lb_stats = per_cpu_ptr(pcpu_lstats, i);
>
> Where "lb_stats" and "pcpu_lstats" are both "const struct pcpu_lstats
> *".  I guess this is because of __verify_pcpu_ptr().

hmm... pcpu_lstats needs to be correctly qualified I guess.

