Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbXFKSgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbXFKSgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXFKSgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:36:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:55703 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbXFKSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BB88UshbJbXfbk8PzGZQ/pI3U4zgav02z8fpBHcG+YTzT1Q+54/h/DGkh67+DsASDo4AQYOY8swkYbslnVDUC9pD6PlI8uPamsNySOEW3Po8YT3LVBozt/pgBdNq7SnGjsAFXKtLK1T26wuCq5uxaI4CjHSH6qzKiuF0O7Y092Q=
Message-ID: <fca78b970706111136q46ffce7cs1b9a49d7b351d281@mail.gmail.com>
Date: Mon, 11 Jun 2007 19:36:41 +0100
From: "Patrick Andrieux" <patrick.andrieux@gmail.com>
To: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
Subject: Re: [PATCH] Kprobes i386 fix for mark ro data
Cc: prasanna@in.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <ak@suse.de>, "Jim Keniston" <jkenisto@us.ibm.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       "David S. Miller" <davem@davemloft.net>,
       "DCCP Mailing List" <dccp@vger.kernel.org>, jbeulich@novell.com,
       systemtap@sources.redhat.com
In-Reply-To: <5640c7e00706092324kd0ea8e0pef4a4cd764fce5d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5640c7e00706061347v42c9ecbahb5354f6687a70a78@mail.gmail.com>
	 <46673B76.2090508@redhat.com>
	 <5640c7e00706061612h62074699wdbd2725654a164@mail.gmail.com>
	 <20070607042229.GA9350@in.ibm.com>
	 <5640c7e00706092324kd0ea8e0pef4a4cd764fce5d3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixed my problem. I re-enabled CONFIG_DEBUG_RODATA and I
don't have seg fault with or without your DCCP patches. Inserting
`dccp_probe` or `tcp_probe`module doesn't cause any troubles.

Patrick.


On 10/06/07, Ian McDonald <ian.mcdonald@jandi.co.nz> wrote:
> On 6/7/07, S. P. Prasanna <prasanna@in.ibm.com> wrote:
> > > >It faulted when it tried to write the breakpoint instruction into the
> > > >running kernel's executable code. Apparently the kernel code is now marked
> > > >read-only?
> > > >
> > > >
> > > Yes it would appear to be the case as user has CONFIG_DEBUG_RODATA
> > > set. Patrick - can you turn this off and retest? It's under Kernel
> > > Hacking, Write protect kernel read only data structures.
> > >
> >
> > Ian,
> >
> > Please find the fix as suggested by Andi Kleen
> > for the above stated problem.
> >
> > Thanks
> > Prasanna
> >
> >
> I went to test the fix and first of all went to replicate the problem.
> My build has CONFIG_DEBUG_RODATA set but the problem does not occur
> without the patch. Should I be concerned about this and raise a bug
> for that as I would think that means there is a problem that the read
> only protection isn't working (this is off Linus' tree synced
> tonight).
>
> Patrick - can you test whether this patch fixes your problem? You said
> disabling CONFIG_DEBUG_RODATA fixed your problem but can you try
> re-enabling and testing this patch?
>
> Ian
> --
> Web: http://wand.net.nz/~iam4/
> Blog: http://iansblog.jandi.co.nz
> WAND Network Research Group
>
