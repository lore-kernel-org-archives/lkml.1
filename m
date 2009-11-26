Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbZKZKZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbZKZKZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760049AbZKZKZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:25:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865AbZKZKZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:25:44 -0500
Subject: Re: [PATCH -tip 1/3] introduce task_times() to replace
 task_{u,s}time() pair
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <4B0E16AE.906@jp.fujitsu.com>
References: <4B061E9A.8040100@jp.fujitsu.com>
	 <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>
	 <4B0B714C.9080607@jp.fujitsu.com> <4B0B8683.6020104@jp.fujitsu.com>
	 <4B0E16AE.906@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 11:25:44 +0100
Message-ID: <1259231144.4273.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 14:48 +0900, Hidetoshi Seto wrote:
> Functions task_{u,s}time() are called in pair in almost all
> cases.  However task_stime() is implemented to call task_utime()
> from its inside, so such paired calls run task_utime() twice.
> 
> It means we do heavy divisions (div_u64 + do_div) twice to get
> utime and stime which can be obtained at same time by one set
> of divisions.
> 
> This patch introduces a function task_times(*tsk, *utime, *stime)
> to retrieve utime and stime at once in better, optimized way.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

OK, the patch looks good, but it does not solve those non monotonic
times funnies that started all this, right?

