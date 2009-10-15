Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZJOMak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZJOMak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZJOMaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:30:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44533 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZJOMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wi1Pp1ale2Wf+krtBmX0GkhlHQ+Q/3Z/pWGK+5xMEWA/wEmNnKhtFSE3tlEXGZlODh
         hC+9awxSnYdlVlwocJBsbERSFrESShATzGLXPEVRNSyb52KmMQhNFsI9mRJdhvddpbeD
         zyZYW8CbVeb75vP4NI++ot9FQ62P2d4fdzzL4=
Date: Thu, 15 Oct 2009 14:28:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: perf report fractal output issue
Message-ID: <20091015122839.GA4960@nowhere>
References: <20091014225726.GF4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014225726.GF4808@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 09:57:26AM +1100, Anton Blanchard wrote:
> 
> Hi,
> 
> I noticed a problem where I wasn't always getting callchains:
> 
> # perf report
>     98.47%  lock1_processes  [kernel]                [k] .lock_kernel
> 
>      0.91%  lock1_processes  [kernel]                [k] .fput
> 
> 
> But a flat output confirmed the data is there:
> 
> # perf report -g flat
>     98.47%  lock1_processes  [kernel]                             [k] .lock_kernel
>             98.47%
>                 .lock_kernel
>                 .__posix_lock_file
>                 (nil)
>                 .fcntl_setlk
>                 .sys_fcntl
>                 syscall_exit
>                 0xfffb7d04844
>                 .testcase
>                 .testcase
>                 .affinitize
>                 .new_task
>                 .main
>                 0xfffb7c4933c
>                 0xfffb7c4955c
>                 (nil)
> 
> It looks like callchain__fprintf_graph() only prints the callchain if we
> have at least one rb entry at the top. In my case all the associated
> backtraces are identical so I assume we dont have to do any splitting.
> 
> Anton


Hmm, could you please send me a perf.data where you can see that?
Does that only happen on powerpc?


Thanks.

