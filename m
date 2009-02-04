Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZBDSSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZBDSSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZBDSSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:18:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbZBDSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:18:02 -0500
Date: Wed, 4 Feb 2009 10:17:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Norbert Preining <preining@logic.at>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
In-Reply-To: <20090204181109.GR21085@gamma.logic.tuwien.ac.at>
Message-ID: <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Norbert Preining wrote:
> 
> The problem is that if you have a configuration under 2.6.28 without
> CONFIG_FB and just call make oldconfig, or even make config and don't
> know that you loose the DRM. And I was using make oldconfig (there is a
> graphical config?? ;-))

Sure. It's inconvenient, no question about that. I asked the i915 people 
to look into not requiring CONFIG_FB, and I hope they will, but my point 
is that I don't think we can consider "small one-time inconvenience" to be 
a "regression".

> So maybe there should be a select FB or so under the CONFIG_DRM option
> (not that I actually can program Kconfig).

CONFIG_FB is one of the things that _could_ be selected for (it doesn't 
depend on anything else that I know about), so just changing the "depends 
on FB" into a "select FB" may get rid of the issue - but it would not 
actually fix your problem, since your CONFIG_DRM_I915 has already been set 
to 'n' by now - so you'd _still_ have to enable it by hand again.

So the upside is not very big - people who have custom configs are the 
often the same people who try -rc1's, so they've already hit this.

			Linus
