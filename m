Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbXJVDfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbXJVDfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXJVDe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:34:57 -0400
Received: from gw.goop.org ([64.81.55.164]:35313 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbXJVDe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:34:56 -0400
Message-ID: <471C1A61.1010001@goop.org>
Date: Sun, 21 Oct 2007 20:34:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-1?Q?Morten_?= =?ISO-8859-1?Q?B=F8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> On Mon, 15 Oct 2007, Nick Piggin wrote:
>
>   
>> Yes, as Dave said, vmap (more specifically: vunmap) is very expensive
>> because it generally has to invalidate TLBs on all CPUs.
>>     
>
> why is that?  ignoring 32-bit archs we have heaps of address space 
> available... couldn't the kernel just burn address space and delay global 
> TLB invalidate by some relatively long time (say 1 second)?
>   

Yes, that's precisely the problem.  xfs does delay the unmap, leaving
stray mappings, which upsets Xen.

    J
