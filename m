Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbZJMOx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbZJMOx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbZJMOx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:53:26 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:59544 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759957AbZJMOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:53:25 -0400
Date: Tue, 13 Oct 2009 10:45:39 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] this_cpu: Use this_cpu_xx in trace_functions_graph.c
In-Reply-To: <4AD49317.6080503@kernel.org>
Message-ID: <alpine.DEB.1.10.0910131043460.8088@gentwo.org>
References: <20091013144812.bdb376aa.sfr@canb.auug.org.au> <4AD48EC4.8040701@kernel.org> <alpine.DEB.1.10.0910131035450.11413@gentwo.org> <4AD49317.6080503@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Tejun Heo wrote:

> Oh... one question tho.  I used __this_cpu_*() as other conversions
> but I think we should be using the version without the underscores.
> The relationship between get_cpu_var() and __get_cpu_var() is
> different from the one between this_cpu_*() and __this_cpu_*().

For operations like inc/add/dec/sub you need to use the version with __
otherwise the arches that do not support these operations will have to
generate useless expensive code that disables / reenables preempt.

For this_cpu_ptr / __this_cpu_ptr it does not matter. this_cpu_ptr gives
you additional checks.

