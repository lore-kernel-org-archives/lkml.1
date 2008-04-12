Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYDLSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYDLSGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYDLSGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:06:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbYDLSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:06:13 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20080412172606.GL11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins>  <20080412172606.GL11962@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 20:05:49 +0200
Message-Id: <1208023549.6230.37.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-12 at 11:26 -0600, Matthew Wilcox wrote:

>  We can continue the
> discussion about eliminating one or the other API, but my opinion is that
> eliminating either is a mistake.  The choice of API indicates how the
> author thinks about the code, which is crucial for those reading the code.

Which is exactly the point, semaphores are rarely the right tool for the
job (I'm currently only aware of XFS that actually uses them as actual
semaphores, and the driver model that uses it to get around lockdep -
still need to come up with a good solution for that).

Even worse, semaphores actively harm the development of linux-rt and
arguably linux kernel development as a whole by not being part of
lockdep - so making a mistake will not be noticed until its too late.

Completions OTOH are not the typical exclusion primitive, they are more
a synchronisation primitive - not unlike wait4(). Typically not things
concerned about priority inversion.


