Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXCEUUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXCEUUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXCEUUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:20:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbXCEUUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:20:52 -0500
Date: Mon, 5 Mar 2007 21:19:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305201957.GA733@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <20070305143437.GF22829@bingen.suse.de> <45EC796D.5050705@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EC796D.5050705@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> [...]  I can't comment on Ingo's patch as he failed to -cc me on it,

it's on lkml, i'll bounce it to you separately.

> despite the fact that we are the only ones affected by it. [...]

actually, no, my motivation for it was KVM (a Linux based hypervisor and 
its paravirtual interface). You said that VMI wont hinder Linux 
development and design in any way and can adopt to whatever change the 
upstream kernel does, so i'm taking your word for that.

> [...] We are not concerned so much with supporting legacy user land 
> deployments, as we expect for the most part, the install scenario to 
> happen when upgrading to new distros.

that's not really the right argument. This obviously affects the host 
kernel too if it has CONFIG_PARAVIRT enabled. The other option is the 
removal (or temporary disabling) of the whole CONFIG_VMI and 
CONFIG_PARAVIRT stuff if you cannot get into minimal release shape, it's 
experimental stuff after all.

> What we really need to do is to be able to detect an old user land and 
> drop VDSO support when that is found.  [...]

no. What you need is to keep existing mechanisms and not hack off the 
vdso and CONFIG_COMPAT_VDSO...

> [...] But since we can't do that, the next best thing is to allow the 
> hypervisor to choose whatever workaround it wants when it moves the 
> fixmap and compat_vdso was enabled.  In our case, the workaround we 
> will want is a boot option to disable VDSO for old user land, [...]

there's no need to disable the VDSO for old userspace ...

	Ingo
