Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYLTLWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYLTLWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYLTLWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:22:45 -0500
Received: from ozlabs.org ([203.10.76.45]:44085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbYLTLWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:22:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/8] cpumask: convert kernel trace functions
Date: Sat, 20 Dec 2008 21:52:39 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <494BD1D0.5080201@sgi.com> <alpine.DEB.1.10.0812192041090.29275@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812192041090.29275@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812202152.40124.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 12:11:49 Steven Rostedt wrote:
> For future memory savings...
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>

Thanks for this Mike, this seems a significant enhancement over the
one in my tree (AFAICT I didn't do ring_buffer.c, nor use on_each_cpu).

I've updated the description, and removed one gratuitous indent change.
It's now in the linux-next section of my tree:

cpumask: convert kernel trace functions

Impact: Reduce future memory usage, use new cpumask API.

(Eventually, cpumask_var_t will be allocated based on nr_cpu_ids, not NR_CPUS).

Convert kernel trace functions to use struct cpumask API:
1) Use cpumask_copy/cpumask_test_cpu/for_each_cpu.
2) Use cpumask_var_t and alloc_cpumask_var/free_cpumask_var everywhere.
3) Use on_each_cpu instead of playing with current->cpus_allowed.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
