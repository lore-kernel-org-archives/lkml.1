Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZCEVyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZCEVyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZCEVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:53:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:59064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCEVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:53:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B2tcGKTssSKCQJcJAxC46Xw9dI8TghytDLtMDI95Abvs5xAgi1QNjfdwaxCFwWjqhH
         ywBk7sMkTnIebHhJ75+C/SaC3tQ0N+uSIWiPbjl25eLPOZZesH1gS5tYNxkIKqBcxYee
         k9DXLu6Z6cQtqqlKcMZnz//as6MWE3R5p1f50=
Date: Fri, 6 Mar 2009 01:00:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090305220044.GA2819@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel> <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236288427.22399.122.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:27:07PM -0800, Dave Hansen wrote:
> > Imagine, unsupported file is opened between userspace checks
> > for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
> > and whatever, you stil have to do all the checks inside checkpoint(2).
> 
> Alexey, we have two problems here.  I completely agree that we have to
> do complete and thorough checks of each file descriptor at
> sys_checkpoint().  Any checks made at other times should not be trusted.
> 
> The other side is what Ingo has been asking for.  How do we *know* when
> we are checkpointable *before* we call (and without calling)

This "without calling checkpoint(2)" results in much complications
as demonstrated.

task_struct and file are not like other structures because they are exposed
in /proc. For PROC_FS=n kernels, one can't even check.

You can do checkpoint(2) without actual dump. You pass, you're most
certainly checkpointable (with inevitable race condition in mind).

With time the amount of stuff C/R won't support will approach zero,
but the infrastructure for "checkpointable" will stay constant.
If it's too much right now, it will be way too much in future.

> sys_checkpoint()?  You are yet to acknowledge that this is a valid use
> case, but it is exactly what Ingo is asking for, I believe.

It's a valid requirement.

> If nice printk()s are sufficient to cover what Ingo wants, I'm quite
> happy to remove the /proc files.  
