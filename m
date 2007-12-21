Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXLUC3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXLUC3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXLUC3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:29:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:57293 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbXLUC3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:29:32 -0500
Subject: Re: PCI resource problems caused by improper address rounding
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <alpine.LFD.0.9999.0712201406190.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com>
	 <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
	 <47680489.6040809@redhat.com>
	 <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
	 <20071218202234.GA24525@twiddle.net>
	 <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
	 <20071218215143.GA24769@twiddle.net>
	 <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org>
	 <20071220215204.GA5636@twiddle.net>
	 <alpine.LFD.0.9999.0712201406190.21557@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 13:28:26 +1100
Message-Id: <1198204106.6779.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So in your case, it should *result* in the exact same situation that your 
> patch did, but at the same time, when dealing with the (more common) case 
> of smaller allocations, we still continue to try to avoid being too close 
> to the top-of-memory.
> 
> So it's not perfect, but perhaps it is a good compromise between being 
> careful and having to make room?
> 
> Does this work for your case?

I'm not totally happy with changing the generic code like that, to
possibly not enforce "min" anymore. Other archs may have very good
reasons to provide a min value here... Though at the same time, at
least on powerpc, the parent resource of the host bridge will be the
real limit, so that may not be a big issue.

Cheers,
Ben.


