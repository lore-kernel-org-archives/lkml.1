Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYG2NcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYG2NcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYG2NcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:32:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52896 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753732AbYG2NcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:32:06 -0400
Date: Tue, 29 Jul 2008 08:32:04 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, jeremy@goop.org
Cc: steiner@sgi.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Comments on UV tlb flushing
Message-ID: <20080729133204.GA13138@sgi.com>
References: <488E644B.10801@goop.org> <200807291412.18495.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807291412.18495.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 02:12:18PM +1000, Nick Piggin wrote:
> On Tuesday 29 July 2008 10:28, Jeremy Fitzhardinge wrote:
> > I'm just reworking the x86 tlb code to use smp_call_function_mask, and I
> > see how the UV tlb flushing hooks in.  A few things occur to me:
> >
> >    1. There should be a CONFIG_X86_UV to select this code.  tlb_uv.o is
> >       around 6k, which is not trivial overhead to subject every x86_64
> >       kernel to.
> 
> Definitely.

I'd like to talk about this issue separate from the virtualization one.

I think that the Linux distributions are not going to build a special
UV kernel, are they?  So every distro would have to be prompted to 
turn on CONFIG_X86_UV, or else their kernel is not going to boot on UV.

But you have a point about not linking the 6k UV object file where 
size is an issue.
Thanks for catching that.

Perhaps the UV code should be excluded if CONFIG_EMBEDDED is set.

-Cliff
