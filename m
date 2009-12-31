Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZLaGN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZLaGN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 01:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZLaGN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 01:13:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59709 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZLaGN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 01:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tEbyfCLVEn32D0yCHaGrn32acO3J02VpGTJmZawCmxNJQpvxzcf8Q2aVJYVexKBX0W
         IzZ8IYclrV9rI9WZ14woJNdy/9dCUAms+W6PAnGlTZRLDE7NmgPvalsVbZ3/MLk0ug3g
         tFka2s0lkDMv9emxbYV/fB5+PAEL4SBF69CD0=
Date: Thu, 31 Dec 2009 07:13:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] perf: Pass appropriate frame pointer to
	dump_trace()
Message-ID: <20091231061352.GA5344@nowhere>
References: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 05:53:02AM +0100, Frederic Weisbecker wrote:
> Pass the frame pointer from the regs of the interrupted path
> to dump_trace() while processing the stack trace.
> 
> Currently, dump_trace() takes the current bp and starts the
> callchain from dump_trace() itself. This is wasteful because
> we need to walk through the entire NMI/DEBUG stack before
> retrieving the interrupted point.
> 
> We can fix that by just using the frame pointer from the captured
> regs. It points exactly where we want to start.



BTW, another effect of this patch: we didn't have the
nmi/debug stack frame filtering in x86-32. So the callchains
were polluted by the perf_callchain path, do_debug and so
on...

After this patch we don't need this filtering anymore
as the nmi/debug frames are zapped. It becomes clean
like in x86-64.

