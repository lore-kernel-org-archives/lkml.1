Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0BRMch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:32:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab0BRMcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:32:35 -0500
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if
 available
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ff13bc9a1002180429p3afc7313sfb65e980b3c198f2@mail.gmail.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <1266488742.26719.119.camel@laptop>
	 <ff13bc9a1002180250t5c9acb54ib8609b4e752520c5@mail.gmail.com>
	 <1266490846.26719.206.camel@laptop>
	 <ff13bc9a1002180429p3afc7313sfb65e980b3c198f2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 13:32:26 +0100
Message-ID: <1266496346.26719.464.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 13:29 +0100, Luca Barbieri wrote:
> >> If we use the stack instead of per-CPU variables, all IRQs and NMIs
> >> preserve CR0 and the SSE registers, so this would be safe, right?
> >
> > You'd have to take special care to deal with nested IRQs I think.
> 
> Could you elaborate on that?
> Which issue could there be with nested IRQs?

Depends on where on the stack you're going to save things, I through
you'd take space in the thread_info struct, but I guess if you're simply
going to push the reg onto the stack it should be fine.

