Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbXCOVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbXCOVUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXCOVUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:20:19 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:26924 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXCOVUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:20:16 -0400
X-AuditID: d80ac287-9e3d5bb000000de9-24-45f9b89061ac 
Date: Thu, 15 Mar 2007 21:20:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: David Howells <dhowells@redhat.com>
cc: bryan.wu@analog.com, Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, haoki@redhat.com,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: Move to unshared VMAs in NOMMU mode?
In-Reply-To: <12852.1173449522@redhat.com>
Message-ID: <Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com>
References: <3378.1173204813@redhat.com>  <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com>
 <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com>
 <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com>
 <18817.1171656543@redhat.com> <29317.1172931029@redhat.com> 
 <12852.1173449522@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Mar 2007 21:20:15.0610 (UTC) FILETIME=[B983A5A0:01C76747]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, David Howells wrote:
> 
> I've been considering how to deal with the SYSV SHM problem, and I think we
> may have to move to unshared VMAs in NOMMU mode to deal with this.  Currently,
> what we have is each mm_struct has in its arch-specific context argument a
> list of VMLs.  Take the FRV context for example:
>... 
> Another way of dealing with the nattch count on NOMMU systems is to do it
> through the VML list, but that then needs more special casing in the SHM
> driver and perhaps others.
> 
> Thoughts?

Thoughts are in regrettably short supply at my end.

I do appreciate all the trouble you've taken to explain it,
in terms I'd understand.  And the way you've taken on board
my anxiety about vma assumptions diverging between NO/MMU.

But if "the SYSV SHM problem" you mention at the beginning
is just the "nattch" problem you mention at the end, I doubt
that's worth such a redesign as you're considering here.

Actually, I'm rather surprised SHM needs any such nattch count,
I'd expect it to deducible from file->f_count and mode&SHM_DEST
(but haven't investigated whether that really works out at all).

If you just need a little CONFIG_MMU in ipc/shm.c to solve your
problem, I don't think more is justified.

Your struct vm_region idea does look more to my taste than what
you presently have; yet if you pursue it, I think it would just
make divergence worse wouldn't it?  NOMMU wanting vma to contain
a pointer to vm_region, MMU wanting vm_region embedded in vma.

I don't really understand why NOMMU chooses to share vmas, or
vm_regions, rather than just sharing the data which they indicate.
Just because you can use less memory that way?  But no need to
justify it now, I'm unlikely to study it in detail.

Hugh
