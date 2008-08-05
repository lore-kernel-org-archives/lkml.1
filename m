Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYHEHx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYHEHx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYHEHxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:53:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYHEHxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:53:19 -0400
Date: Tue, 05 Aug 2008 16:45:30 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Control groups and Resource Management notes (part II)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Containers <containers@lists.osdl.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
In-Reply-To: <4893B415.9070906@linux.vnet.ibm.com>
References: <489315B2.2080506@linux.vnet.ibm.com> <4893B415.9070906@linux.vnet.ibm.com>
Message-Id: <20080805160709.A88B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi balbir-san,

Thank you for nice minutes.
it is very helpful for non invited people (include me).


> 10. Freezer subsystem - The freezer system was discussed briefly. Serge
> mentioned the patches and wanted to collect feedback (if any) on them.

Who use it?

AFAIK the freezer is used by HPC guys in general.
but they think MPI process must be freezed.

Unfortunately, Opensource MPI implementation use various inter-process
communication method (e.g. SYSV IPC, socket, ptrace)

then, general freezer implementaion is very difficult.


> 11. OOM Handler - The OOM handler was discussed in detail. Balbir mentioned
> certain short comings of the OOM handler
> 	a. Logic - it is based on total_vm, is that the correct metric for
>                    OOMing?
> 	b. Concurrency - it kills several tasks at once
> 
> There was a discussion on moving the policy for OOM handling to user space. Paul
> described how the OOM handler has been modified at google to notify user space
> when a CPUSet runs out of memory. Balbir asked if OOMing on reaching limits is a
> good idea, it was generally discussed that it might not be such a good idea.

CPUSET based limitation is not easy to use (slightly).
memcgroup based is better.

In addition, notification on reaching limit can be very generic.

various limit (e.g. cpu time, memory usage), various notification
(e.g. kill process, send signal, inotify), various target
(each process on the cgroup or manager process) can be tought.



> Control group library
> =====================
> Dhaval and Balbir introduced libcgroups and the purpose of the library and the
> goals. Balbir described on paper what the current design looks like, it consists of
> 
> 	1. API
> 	2. Test framework
> 	3. A configuration subsystem
> 
> Dhaval discussed configuration syntax of XML versus home made. The issue of
> classification of tasks was brought up. The reason that we want to classify
> tasks is that we want them to move at fork/exec time to the correct cgroup so that

I don't recommend XML, because XML is tree based syntax but we want more fulexible
classification. then I guess XML reduce human readability.


> 1. They don't consume resources in the parents group
> 2. The movement is automatic
> 
> It was generally agreed upon that the classification should take place in user
> space. Eric and others suggested having a wrapper to start the application in
> the correct cgroup (wrapper around fork/exec). Dave suggested that one might
> even go the extent of hacking, such that a process is ptraced after fork/exec,
> moved to the correct group and resumed. Using SELinux contexts was also recommended.
> 
> Vivek brought up using PAM plugins to do classifications, this suggestion was
> nicely received. The decision was to do classification in user space and then
> think of kernel space if it cannot be done in user space. Denis suggested that
> classification is useful. In OpenVZ they classify all apache children to a
> different group. Balbir asked Denis to post their classification infrastructure
> as RFC.

I'm not sure about this issue.
but I like PAM approach.



