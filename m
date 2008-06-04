Return-Path: <linux-kernel-owner+w=401wt.eu-S1762119AbYFDTZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119AbYFDTZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbYFDTZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:25:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54177 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756640AbYFDTZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:25:44 -0400
Date: Wed, 4 Jun 2008 14:25:40 -0500
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and
 mems_allowed after CPU/NODE offline/online
Message-Id: <20080604142540.6fa2bcc3.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.10.0806041149560.21323@chino.kir.corp.google.com>
References: <4845F864.8060102@cn.fujitsu.com>
	<6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com>
	<6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com>
	<20080604122227.a092e70e.pj@sgi.com>
	<alpine.DEB.1.10.0806041149560.21323@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> That would only identify kthreads that have been created with a subsequent 
> call to set_cpus_allowed() or kthread_bind().
> 
> The PF_CPU_BOUND change targets only the latter since there are kthreads, 
> such as kstopmachine, that can continue to manipulate their cpus_allowed 
> during their lifetime.

Would your first sentence be more clearly written as:

> That would identify both kthreads that have been created with a subsequent 
> call to set_cpus_allowed() or kthread_bind().

Or do I misunderstand?

If I am reading you correctly, then would it work to have a check in the
cpuset code (rather than in the lower set_cpus_allowed() routine),
where that check refused to move tasks out of the root cpuset if they
were (1) kernel threads (mm NULL) and (2) had cpus_allowed that were a
strict subset of the root cpusets 'cpus' (the online cpus).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
