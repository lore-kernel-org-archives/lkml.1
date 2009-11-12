Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZKLOQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZKLOQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZKLOQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:16:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:48625 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZKLOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:16:09 -0500
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <4AFB9029.9000208@jp.fujitsu.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>
	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop>
	 <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com>
	 <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com>
	 <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com>
	 <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com>
	 <4AFB8C21.6080404@jp.fujitsu.com>  <4AFB9029.9000208@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 15:15:58 +0100
Message-ID: <1258035358.4039.374.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 13:33 +0900, Hidetoshi Seto wrote:
> Originally task_s/utime() were designed to return clock_t but later
> changed to return cputime_t by following commit:
> 
>   commit efe567fc8281661524ffa75477a7c4ca9b466c63
>   Author: Christian Borntraeger <borntraeger@de.ibm.com>
>   Date:   Thu Aug 23 15:18:02 2007 +0200
> 
> It only changed the type of return value, but not the implementation.
> As the result the granularity of task_s/utime() is still that of
> clock_t, not that of cputime_t.
> 
> So using task_s/utime() in __exit_signal() makes values accumulated
> to the signal struct to be rounded and coarse grained.
> 
> This patch removes casts to clock_t in task_u/stime(), to keep
> granularity of cputime_t over the calculation.
> 
> v2:
>   Use div_u64() to avoid error "undefined reference to `__udivdi3`"
>   on some 32bit systems.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

/me hates all the cputime_t and clock_t mess.. but I guess the patch is
good.

Thanks.


