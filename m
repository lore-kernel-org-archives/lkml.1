Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbXI1RDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbXI1RDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXI1RDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:03:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXI1RDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:03:45 -0400
Message-ID: <46FD33DF.2010605@zytor.com>
Date: Fri, 28 Sep 2007 10:03:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jkeating@redhat.com, cebbert@redhat.com, jordan.crouse@amd.com,
       pommnitz@yahoo.com
Subject: Re: [GIT PULL] Correct the SMAP check in the e820 probe
References: <200709280856.l8S8uvS5002291@tazenda.hos.anvin.org> <alpine.LFD.0.999.0709280719010.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709280719010.3579@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Hmm. If I read this correctly, I don't think this can be right.
> 
> Why? You don't mark %edx as possibly corrupted by the asm any more.
> 
> The "=dm" means that quite often (probably effectively always), gcc will 
> allocate %edx to be the output register for %0, but at least in theory, it 
> could easily decide that it's going to put %0 in memory, and in that case, 
> it may well decide that %edx is not modified by the asm statement. Which 
> may or may not be true - I'd bet that there are BIOSes out there that *do* 
> modify it.
> 

Yes indeed.

> 
> IOW, I think you need to either (a) _force_ gcc to use %edx for the "err" 
> return, avoiding this issue, or (b) mark edx clobbered (which in turn 
> means that you need to remove it from the output constraint for "err"). I 
> suspect (a) is simpler/more straightforward.
> 
> I haven't pulled this, so maybe you can just amend the commit in-place, 
> and we can avoid?
> 

Will do.

	-hpa
