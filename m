Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXDLXGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXDLXGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXDLXGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:06:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXDLXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:06:34 -0400
Message-ID: <461EBB68.8010408@redhat.com>
Date: Thu, 12 Apr 2007 19:06:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org> <200704122321.23318.ak@suse.de> <461EB938.6080807@goop.org>
In-Reply-To: <461EB938.6080807@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>>> (This was under Xen, but there's no reason it couldn't happen on bare
>>>   hardware.)
>>>     
>> Hmm, does Xen perhaps not use interrupt stacks?
> 
> Looks like that's all done in do_IRQ, so it should be independent of
> whether its Xen or not.  And the stack overflow check is performed on
> the main stack, before switching to the interrupt stack.
> 

Yeah, the do_IRQ thing is misleading because it makes you think the
interrupt caused an overflow when all it did was detect a
near-overflow condition. (The number printed is the amount of space
left.)
