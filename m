Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbYCFNea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbYCFNea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933894AbYCFNd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:33:56 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:47595 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbYCFNdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:33:55 -0500
From: Srinivasa DS <srinivasa@in.ibm.com>
Organization: IBM
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [BUG] Kprobes fails on 2.6.25-rc3-mm1 (x86) systems, if CONFIG_DEBUG_RODATA is set.
Date: Thu, 6 Mar 2008 19:03:08 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>
References: <200803061811.27555.srinivasa@in.ibm.com> <20080306125551.GA1597@Krystal>
In-Reply-To: <20080306125551.GA1597@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061903.09003.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 06:25:51 pm Mathieu Desnoyers wrote:
> * Srinivasa DS (srinivasa@in.ibm.com) wrote:
> > Insertion of kprobe module causes oops on 2.6.25-rc3-mm1 (x86) systems if
> > we enable CONFIG_DEBUG_RODATA.  While registering the probe, memcpy()
> > fails to copy breakpoint instruction to the instruction address and
> > generates the oops.
> >
> > BUG: unable to handle kernel paging request at ffffffff8047d1a7
> > IP: [<ffffffff8047ff62>] text_poke+0xa/0x10
> > PGD 203067 PUD 207063 PMD 7e191163 PTE 47d161
> > Oops: 0003 [1] PREEMPT SMP
> > ................................................
> >
> > This is because, Mathieu's patch (http://lkml.org/lkml/2008/2/2/226)
> > makes entire text segment as READONLY, if we enable CONFIG_DEBUG_RODATA.
> >
> > So reverting this patch or new patch, which considers kprobes while
> > deciding boundary for setting readonly pages might solve the probelm.
>
> Hi,
>
> Are you running under Xen, lguest, kvm.. ?

No, on a bare x86_64 system.   That shouldn't matter for this bug, A quick 
look at the call path shows me this.
     start_kernel()->rest_init()->kernel_init()->init_post()->mark_rodata_ro()

Srinivasa DS
>
> Mathieu
>
> > Thanks
> >  Srinivasa DS
> >  LTC-IBM


