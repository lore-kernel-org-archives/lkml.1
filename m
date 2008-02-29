Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYB2GyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYB2GyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYB2GyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:54:05 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45165 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751848AbYB2GyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:54:03 -0500
Date: Fri, 29 Feb 2008 00:53:54 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080229005354.21631c09.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802281945060.31783@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
	<20080228113728.7b8e5811.pj@sgi.com>
	<alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com>
	<20080228164637.114fb19d.pj@sgi.com>
	<alpine.DEB.1.00.0802281452340.13082@chino.kir.corp.google.com>
	<20080228181611.49671331.pj@sgi.com>
	<alpine.DEB.1.00.0802281659460.3158@chino.kir.corp.google.com>
	<20080228213402.7260906f.pj@sgi.com>
	<alpine.DEB.1.00.0802281945060.31783@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> @@ -1162,6 +1162,8 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
>  
>  	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
>  		return -ENOSPC;
> +	if (tsk->flags & PF_THREAD_BOUND)
> +		return -EINVAL;
>  
>  	return security_task_setscheduler(tsk, 0, NULL);
>  }

I'm ok with this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
