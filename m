Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbXCEQ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbXCEQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXCEQ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:56:16 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59224 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbXCEQ4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:56:14 -0500
Date: Mon, 5 Mar 2007 22:32:44 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: menage@google.com, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070305170244.GA17151@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com> <20070303093655.GA1028@in.ibm.com> <20070303022100.8cee6997.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303022100.8cee6997.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 02:21:00AM -0800, Paul Jackson wrote:
> Perhaps you could summarize what becomes of this hook, in this
> brave new world of rcfs ...

attach_task() still uses a synchronize_rcu before doing a put_nsproxy in
the rcfs patches. This means cpuset_update_task_memory_state() can read a 
task's cpuset->mems_generation under just a rcu_read_lock() (as it is
doing currently).

void cpuset_update_task_memory_state(void)
{
	tsk = current;
	...

        } else {
                rcu_read_lock();
                ns = rcu_dereference(tsk->nsproxy);
                my_cpusets_mem_gen = 
			ns->ctlr_data[cpuset_ctlr.subsys_id]->mems_generation;
                rcu_read_unlock();
        }

	...
}


-- 
Regards,
vatsa
