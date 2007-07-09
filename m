Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXGIGXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXGIGXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXGIGWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:22:55 -0400
Received: from gw.goop.org ([64.81.55.164]:34893 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXGIGWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:22:54 -0400
Message-ID: <4691D41C.7050405@goop.org>
Date: Sun, 08 Jul 2007 23:22:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>	<4691B9A5.6060203@yahoo.com.au> <87k5taw5vc.fsf@jbms.ath.cx>	<4691BD6F.8000809@yahoo.com.au> <87fy3yw50p.fsf@jbms.ath.cx>
In-Reply-To: <87fy3yw50p.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
> It would indeed be a pain for the new kernel to be loaded and have to
> use discontiguous memory.  The trick is, though, that this is not
> necessary.  Immediately before jumping to the new kernel, the first X
> bytes (where X is the amount of memory the new kernel will get,
> typically 16MB or 64MB) of physical memory are backed up into the
> arbitrary discontiguous pages that are made available.  This will not
> take very long, because copying even 64MB of memory is extremely fast.
> Then the new kernel is free to use the first X bytes of contiguous
> physical memory.  Problem solved.
>   

You could also use the paravirt_ops pte hooks to create a mapping from 
linear "physical" addresses to actual machine pages.  This is what a Xen 
kernel needs to do, and all the infrastructure will be in place shortly.

    J
