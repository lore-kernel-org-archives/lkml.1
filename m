Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbZAUEFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbZAUEFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZAUEFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:05:36 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39816 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763523AbZAUEFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:05:35 -0500
Date: Tue, 20 Jan 2009 22:05:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, bastian@waldi.eu.org, oleg@redhat.com,
       ebiederm@xmission.com, containers@lists.osdl.org, roland@redhat.com,
       xemul@openvz.org
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
Message-ID: <20090121040530.GA17373@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com> <20090119110906.58ccbcbd.kamezawa.hiroyu@jp.fujitsu.com> <20090121030500.GA32138@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121030500.GA32138@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> KAMEZAWA Hiroyuki [kamezawa.hiroyu@jp.fujitsu.com] wrote:
> | On Sat, 17 Jan 2009 12:26:38 -0800
> | Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:
> | 
> | > 
> | > Container-init must behave like global-init to processes within the
> | > container and hence it must be immune to unhandled fatal signals from
> | > within the container (i.e SIG_DFL signals that terminate the process).
> | > 
> | > But the same container-init must behave like a normal process to 
> | > processes in ancestor namespaces and so if it receives the same fatal
> | > signal from a process in ancestor namespace, the signal must be
> | > processed.
> | > 
> | > Implementing these semantics requires that send_signal() determine pid
> | > namespace of the sender but since signals can originate from workqueues/
> | > interrupt-handlers, determining pid namespace of sender may not always
> | > be possible or safe.
> | > 
> | 
> | Is this feature is for blocking signals from children to name-space
> | creator(owner) ?  And automatically used when namespace/cgroup is created ?
> | IOW, Container-init is Namespace-Cgroup-init ? 
> 
> I am not sure what "Namespace-cgroup-init refers" to.

It sounds like he means the first task in a newly created
ns cgroup.  In which case he would mean any task which has
done an unshare with any of CLONE_NEWNS, CLONE_NEWIPC, etc,
or is the result of clone with the same.

> But, yes, this patchset applies to the first process in a pid namespace
> i.e the child of clone(NEWPID) call.
> 
> | 
> | I'm glad if you add some documentation updates about how-it-works to patch set.
> 
> Yes,  when the patchset is accepted, I am planning to add some notes to
> /sbin/init man page. 
> 
> Thanks,
> 
> Sukadev
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
