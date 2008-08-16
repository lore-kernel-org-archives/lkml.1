Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYHPDQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYHPDQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYHPDQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:16:37 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:15295 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558AbYHPDQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:16:37 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
References: <20080813083953.GF19333@ics.muni.cz>
	<ye8myjg7b4r.fsf@camel10.daimi.au.dk>
	<20080814111022.GC4674@ics.muni.cz>
	<ye84p5l7jwp.fsf@camel28.daimi.au.dk>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 16 Aug 2008 05:16:34 +0200
In-Reply-To: <ye84p5l7jwp.fsf@camel28.daimi.au.dk>
Message-ID: <ye8myjd644t.fsf@camel28.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sandmann <sandmann@daimi.au.dk> writes:

> Lukas Hejtmanek <xhejtman@ics.muni.cz> writes:
> 
> > On Thu, Aug 14, 2008 at 01:23:16AM +0200, Soeren Sandmann wrote:
> > > It's somewhat rough still. If you try it out, I will be interested in
> > > any feedback you have.
> > 
> > another feedback. I got No map at all processes even at those I got debug info
> > installed.
> 
> This may be because sysprof user space is not running as root, or it
> may be because the kernel is generating bogus addresses. 
> 
> Generally, "No Map" means sysprof is seeing samples in memory regions
> that are not in /proc/<pid>/maps

Actually, I seem to remember one cause of this: the vdso code creates
an unusual stackframe where the pointer to the previous frame is
stored in an unusual place. I think the sysprof kernel code needs to
take this into account, or alternatively send sufficient information
to userspace that it can figure it out itself.


Soren
