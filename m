Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXJVSh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXJVSh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXJVShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:37:50 -0400
Received: from gw.goop.org ([64.81.55.164]:57301 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXJVSht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:37:49 -0400
Message-ID: <471CEDFD.3030603@goop.org>
Date: Mon, 22 Oct 2007 11:37:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: dean gaudet <dean@arctic.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-1?Q?Morten_?= =?ISO-8859-1?Q?B=F8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <471C1A61.1010001@goop.org> <alpine.DEB.0.9999.0710212128180.2320@twinlark.arctic.org> <200710221439.21503.nickpiggin@yahoo.com.au>
In-Reply-To: <200710221439.21503.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> You could call it a bug I think. I don't know much about Xen though,
> whether or not it expects to be able to run an arbitrary OS kernel.
>   

Xen's paravirtualized mode always requires a guest OS to be modified;
certainly some operating systems would be very hard to make work with
Xen.  But you can always fall back to using shadow pagetables or full
hvm (VT/SVM) mode.

> Presumably, the hypervisor _could_ write protect and trap writes to
> *all* page table page mappings.
>   

Xen manages this stuff with refcounts; it doesn't maintain an rmap for
these pages, so it would have to exhaustively search to do this.  But
aside from that, Xen never actively modifies pagetables, so this would
be a new behaviour in the interface.

    J
