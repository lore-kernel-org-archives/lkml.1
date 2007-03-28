Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbXC1OsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbXC1OsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXC1OsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:48:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39224 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXC1OsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:48:12 -0400
Date: Wed, 28 Mar 2007 20:25:34 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, menage@google.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070328145534.GT11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070324050537.GA27040@in.ibm.com> <20070324162326.GC11794@in.ibm.com> <20070326215755.GC10492@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326215755.GC10492@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 04:57:55PM -0500, Serge E. Hallyn wrote:
> That is still not true, see kernel/utsname:copy_utsname().
> 
> Now you might have run a userspace testcase in a kernel with
> CONFIG_UTS_NS=n, which at the moment erroneously returns 0 rather than
> -EINVAL when you clone(CLONE_NEWUTS).  But you didn't get a new uts
> namespace, you were just lied to  :)

I think you are right here, in that CONFIG_UTS_NS was not turned on,
although I was thinking it was on.

However as a result of this experiment, I found this anomaly:

- On a kernel with CONFIG_UTS_NS=n, a test which does
  clone(CLONE_NEWUTS) works fine. clone() succeeds and the child
  starts running with no error.
- On the same kernel, if ns container hierarchy is mounted, then
  the test fails. clone() returns failure and child is never created.
  As soon as the ns container hierarchy is unmounted, the test works
  again.

I would have expected a consistent behavior here, irrespective of
whether ns hierarchy is mounted or not. Is this difference in behavior
acceptable? Returning -EINVAL in copy_utsname() when CONFIG_UTS_NS=n, as
you say above, would fix this anomaly.


-- 
Regards,
vatsa
