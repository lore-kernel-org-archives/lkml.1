Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZDNUtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZDNUtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZDNUtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:49:02 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47429 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZDNUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F6HjSbO4xkzgDQ8PnznFsRBsOG0BlZBFNCscaMpOTXHSjVQbRjaNlzvOcVUBPhh9N+
         gGWvO0twofvGcpiZPN+ZhXJGeDeIQ/hZm4pmmd9+813t4piXA/g8MxIpmuLELyBF+4UW
         ASMKS0AeX7erBqzeOCsMfs5CG+ELZ7lQodOTs=
Date: Wed, 15 Apr 2009 00:49:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090414204912.GA28458@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain> <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4D115.5080601@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> * not having CAP_SYS_ADMIN on restart(2)
> >> Surely you have read already on the containers mailing list that
> >> for the *time being* we attempt to get as far as possible without
> >> requiring root privileges, to identify security hot-spots.
> > 
> > More or less everything is hotspot.
> 
> Going back to my example of a subtree above: what sort of security
> issues you would have here, assuming all restart operations go via
> the usual security checks just like syscalls, and we take special
> care about values we allow as input, e.g. cpu debug registers etc ?

This is like asking if everything goes through correct security checks
how will you screw something up. Everything won't go via usual security
checks.

Just for giggles, writing exploit for localhost hole becomes easier --
you very effectively turn off all randomization kernel does because VMA
boundaries comes from disk.

> BTW, the checks for cpu registers and other values for sanity is
> needed anyway to ensure that the kernel freak out if wrong input
> is fed (maliciously or by mistake).

Out of head, mucking with registers of setuid program is no-no.
As well as mucking with dirty data of setuid program.

Capabilities will come from disk.

Many EPERM checks are suspect.

do_arch_prctl(ARCH_SET_GS) has TASK_SIZE check, do you?

> >> And surely you have read there the observation that for the general
> >> case root privileges will probably be inevitable.
> >>
> >> And surely you don't seriously think that adding this check changes
> >> the "design"...
> > 
> > This is not about design now, this is about if you allow restart(2) for
> > everyone, you open kernel to very very high number of holes of all
> > types. I wrote about it in reply to your code.
> > 
> 
> And there are many examples where this is not the case. The current
> patchset (v14-rc3), for example, to the best of my knowledge, does
> not have such issues (well, need to add checks for validity of regs
> but there is a FIXME comment :)

And such an obvious issue like segmentt RPL is fixed? :-)
