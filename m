Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZJGCpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZJGCpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZJGCo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:44:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48252 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZJGCo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:44:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=L49D8GLwBKOJKNqU4O1PsUq/+/cfpE2+F8iLDfbMNOtsPQKt0IIjKs9sDwsxIr5W9
	0kH3FB5rqHBSUzUGAU+9Q==
Date: Tue, 6 Oct 2009 19:43:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] kbuild: Improve version string logic
In-Reply-To: <20091006173508.GA4786@elte.hu>
Message-ID: <alpine.DEB.1.00.0910061911190.2975@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <20091006173508.GA4786@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Ingo Molnar wrote:

> Subject: kbuild: Improve version string logic
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 6 Oct 2009 09:31:03 -0700 (PDT)
> 
> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
> way:
> 
>  - if it is set, things work the way they always have, and you get a
>    extended kernel release like:
> 
> 	2.6.32-rc3+00052-g0eca52a-dirty
> 
>    ( with the difference that the extra version string is separated via
>      '+' not via '-'. This improves visibility when we have additional
>      changes over a vanilla tag. )
> 

s/changes/commits/, we'd have to look at the -dirty suffix for uncommited 
changes.

The '+' doesn't necessarily always mean there are additional changes since 
scripts/setlocalversion will return -00000-EXTRAVERSION when we're at a 
release.  So when CONFIG_LOCALVERSION_AUTO is enabled, this patch would, 
for example, create the version 2.6.32-rc3+00000-rc3.

Perhaps we should suppress setlocalversion's output if git describe 
doesn't have a 7-character trailing hash prefixed with 'g'?
