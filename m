Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbXJOL2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbXJOL2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbXJOL23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:28:29 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:40949 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752227AbXJOL22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:28:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZfWhGiOaG5IPC/v2tDGjJNIBGiVmHQ703r7cQbGr6Oi0xD46pDJyfnukBOf3v81OnZtinuF+vjeql7z2TWDYfXsPAYF71OgTZZ93F8SnHr4kuiuERpl4YpC+qHWBP3rD47lPZ6yPBDem1nomGAPRltTQrPuz854Kofmu+l1A28c=  ;
X-YMail-OSG: Mn_R.lQVM1mWmfpccn3aykAJ8mrBrilycYG44ebjNPjTqTb_K7umCQYWvnyA9UIwyOwgvFsAHQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Date: Mon, 15 Oct 2007 21:28:10 +1000
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?q?B=C3=B8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
References: <470FA7C3.90404@goop.org> <200710160056.47458.nickpiggin@yahoo.com.au> <20071015110735.GA11748@one.firstfloor.org>
In-Reply-To: <20071015110735.GA11748@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152128.10900.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 21:07, Andi Kleen wrote:
> On Tue, Oct 16, 2007 at 12:56:46AM +1000, Nick Piggin wrote:
> > Is this true even if you don't write through those old mappings?
>
> I think it happened for reads too.  It is a little counter intuitive
> because in theory the CPU doesn't need to write back non dirty lines,
> but in the one case which took so long to debug exactly this happened
> somehow.
>
> At it is undefined for reads and writes in the architecture so
> better be safe than sorry.

Yes, typo. I meant reads or writes.


> And x86 CPUs are out of order and do speculative executation
> and that can lead to arbitary memory accesses even if the code
> never touches an particular address.
>
> Newer Intel CPUs have something called self-snoop which was supposed
> to handle this; but in some situations it doesn't seem to catch it
> either.

Fair enough, so we have to have this lazy tlb flush hook for
Xen/PAT/etc. I don't think it should be much problem to
implement.


> > Is DRM or AGP then not also broken with lazy highmem flushing, or
> > how do they solve that?
>
> AGP doesn't allocate highmem pages.  Not sure about the DRM code.

Hmm, OK. It looks like DRM vmallocs memory (which gives highmem).
