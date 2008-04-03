Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYDCNOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYDCNOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYDCNOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:14:16 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58611 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbYDCNOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:14:15 -0400
Date: Thu, 3 Apr 2008 08:14:11 -0500
From: Paul Jackson <pj@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
Message-Id: <20080403081411.aae6a064.pj@sgi.com>
In-Reply-To: <47F44D25.6030001@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
	<20080401065534.a6267b96.pj@sgi.com>
	<47F34625.6000600@jp.fujitsu.com>
	<20080402061405.197c0c90.pj@sgi.com>
	<47F44D25.6030001@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.Seto wrote:
> I believe there are quite technical reasons why we have no "idle_map."

I would not advocate a single system wide cpumask of idle CPUs.  As
Peter Zijlstra notes in a follow up post, that's too hot a cache line
and clearly doesn't scale.

But I would think it would be ok to have a separate cpumask per node,
that marked just the node-local CPUs.  We have other per-node data
already.  If we only support this optional load balancing level across
the other CPUs on the same node (or smaller domains, such as the cores
in a package), that should work, shouldn't it?

> so I'll update my patch to take levels, getting in your suggestion.

If you see a good solution here that you can provide, good.  But if my
brain storming ideas have problems, don't hesitate to object to them.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
