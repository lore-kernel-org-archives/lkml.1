Return-Path: <linux-kernel-owner+w=401wt.eu-S966017AbXFFXMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017AbXFFXMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965434AbXFFXMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:12:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:14777 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbXFFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:12:33 -0400
Message-ID: <5640c7e00706061612h62074699wdbd2725654a164@mail.gmail.com>
Date: Thu, 7 Jun 2007 11:12:32 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: [BUG] Fwd: segfault : modprobe dccp_probe/tcp_probe
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       "David S. Miller" <davem@davemloft.net>,
       "Patrick Andrieux" <patrick.andrieux@gmail.com>,
       "DCCP Mailing List" <dccp@vger.kernel.org>, jbeulich@novell.com
In-Reply-To: <46673B76.2090508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5640c7e00706061347v42c9ecbahb5354f6687a70a78@mail.gmail.com>
	 <46673B76.2090508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 06/06/2007 04:47 PM, Ian McDonald wrote:
> > Hi there,
> >
> > We've seen a report of a problem with dccp_probe as shown below. The
> > user has also verified that it occurs in tcp_probe as well. This is on
> > Dave Miller's tree but that currently tracks Linus' tree quite
> > closely. I do note that it is around 2.6.22-rc2 timeframe so there is
> > a possibility fixes may have gone in since.
> >
>
> It faulted when it tried to write the breakpoint instruction into the
> running kernel's executable code. Apparently the kernel code is now marked
> read-only?
>
>
Yes it would appear to be the case as user has CONFIG_DEBUG_RODATA
set. Patrick - can you turn this off and retest? It's under Kernel
Hacking, Write protect kernel read only data structures.

The list of commits that I see around this are at:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=HEAD&st=commit&s=DEBUG_RODATA

I suspect it's probably one of the latter ones giving the timing.

I guess there are a couple of solutions here - either make kprobes
conflict with CONFIG_DEBUG_RODATA so you can do one or the other, or
look into more detail what access kprobes need.

Ian
-- 
Web: http://wand.net.nz/~iam4/
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
