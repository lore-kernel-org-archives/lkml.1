Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXC1P0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXC1P0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXC1P0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:26:24 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51238 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXC1P0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:26:23 -0400
Date: Wed, 28 Mar 2007 10:26:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, menage@google.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070328152619.GA24301@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070324050537.GA27040@in.ibm.com> <20070324162326.GC11794@in.ibm.com> <20070326215755.GC10492@sergelap.austin.ibm.com> <20070328145534.GT11794@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328145534.GT11794@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Mon, Mar 26, 2007 at 04:57:55PM -0500, Serge E. Hallyn wrote:
> > That is still not true, see kernel/utsname:copy_utsname().
> > 
> > Now you might have run a userspace testcase in a kernel with
> > CONFIG_UTS_NS=n, which at the moment erroneously returns 0 rather than
> > -EINVAL when you clone(CLONE_NEWUTS).  But you didn't get a new uts
> > namespace, you were just lied to  :)
> 
> I think you are right here, in that CONFIG_UTS_NS was not turned on,
> although I was thinking it was on.
> 
> However as a result of this experiment, I found this anomaly:
> 
> - On a kernel with CONFIG_UTS_NS=n, a test which does
>   clone(CLONE_NEWUTS) works fine. clone() succeeds and the child
>   starts running with no error.
> - On the same kernel, if ns container hierarchy is mounted, then
>   the test fails. clone() returns failure and child is never created.
>   As soon as the ns container hierarchy is unmounted, the test works
>   again.
> 
> I would have expected a consistent behavior here, irrespective of
> whether ns hierarchy is mounted or not. Is this difference in behavior
> acceptable? Returning -EINVAL in copy_utsname() when CONFIG_UTS_NS=n, as
> you say above, would fix this anomaly.

Will, not would, fix the anomaly  :)

2.6.21-rc5-mm2 has the correct behavior.  Returning 0 was a bug.

thanks,
-serge
