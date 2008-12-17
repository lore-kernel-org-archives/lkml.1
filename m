Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759837AbYLQJLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbYLQJLQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYLQJLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:11:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46202 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYLQJK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:10:59 -0500
Date: Wed, 17 Dec 2008 09:10:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217091058.GB28946@ZenIV.linux.org.uk>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217085539.GA4152@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 09:55:39AM +0100, Sam Ravnborg wrote:

> > AFAICS, having archprepare depend on user_constants.h and kern_constants.h
> > would do just fine.  Note that we don't care how these two are ordered;
> > it's asm-offsets.h that can't be created without user_constants.h.
> 
> Agreed.
> 
> Previously we had some race issues in the arch Makefile when they used
> the prepare target and they were workaround in various ways.
> This was why we introduced archprepare in the first place IIRC.
> And I also recall that um was starnge but this is all cleaned up now - good.

FWIW, how do you plan to deal with include/asm once everything gets moved
to arch/*/include/asm?

Right now O=... builds create asm-offsets.h in $(objtree)/include/asm; do
you plan to take it to $(objtree)/arch/$(ARCH)/include/asm?

Another bloody annoying thing is dangling include2/asm on such builds, along
with include/asm-x86 created on non-O=.. ones.

If/when we stop doing that and just put asm-offsets.h into arch/*/include/asm
we'll need to update the rule for kern_constants.h to
$(SHARED_HEADERS)/kern_constants.h:
	$(Q)mkdir -p $(dir $@)
	$(Q)echo '#include "../asm/asm-offsets.h"' >$@
Not a big deal, just something that'll need to be taken care of when we
switch...
