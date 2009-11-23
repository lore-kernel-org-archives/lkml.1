Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZKWKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZKWKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZKWKZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:25:27 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51036 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZKWKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:25:26 -0500
Date: Mon, 23 Nov 2009 15:55:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
Message-ID: <20091123102528.GT31961@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4AFB9029.9000208@jp.fujitsu.com>
 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
 <1258038038.4039.467.camel@laptop>
 <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
 <4B01A8DB.6090002@bluehost.com>
 <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com>
 <1258464288.7816.305.camel@laptop>
 <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com>
 <4B05F835.10401@jp.fujitsu.com>
 <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stanislaw Gruszka <sgruszka@redhat.com> [2009-11-23 11:09:26]:
[snip]
> +
> +		utime = task_utime(tsk);
> +		stime = task_stime(tsk);
> +		if (tsk->utime > utime || tsk->stime > stime) {
> +			utime = tsk->utime;
> +			stime = tsk->stime;
> +		}

Won't this condition be problematic, since it can reset stime
when tsk->utime > utime for example?
-- 
	Balbir
