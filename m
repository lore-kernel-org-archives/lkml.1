Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbYEOOxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbYEOOxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYEOOxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:53:38 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43188 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbYEOOxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:53:37 -0400
Date: Thu, 15 May 2008 20:32:30 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, npiggin@suse.de, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] sched: Improve readability in update_cpu_load() code
Message-ID: <20080515150230.GE14823@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080515130459.GA9650@in.ibm.com> <20080515145215.GD14823@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515145215.GD14823@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 08:22:15PM +0530, Srivatsa Vaddagiri wrote:
> This wont work when new_load < old_load ..
> 
> For ex: I tried this prog:
> 
> #include <stdio.h>
> 
> main()
> {
> 	unsigned long old_load = 100, new_load = 90, this_load, this_load1;
> 	int i = 1, scale = 2 << i;

s/scale = 2<< i/scale = 2 << (i-1)

> 
> 	this_load = (old_load*(scale-1) + new_load) >> i;
> 	this_load1 = old_load + ((new_load - old_load) >> i);
> 
> 	printf ("this_load = %u, this_load1 = %u \n", this_load, this_load1);
> }
> 
> This is what I get:
> 
> $ ./a.out
> this_load = 195, this_load1 = 2147483743
> $

[with above modification:]

this_load = 95, this_load1 = 2147483743


-- 
Regards,
vatsa
