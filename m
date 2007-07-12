Return-Path: <linux-kernel-owner+w=401wt.eu-S937499AbXGLAni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937499AbXGLAni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbXGLAn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:43:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776AbXGLAnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:43:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: Jeremy Fitzhardinge's message of  Wednesday, 11 July 2007 16:57:23 -0700 <46956E63.5090607@goop.org>
Emacs: Lovecraft was an optimist.
Message-Id: <20070712004249.A59D84D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 17:42:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Is .notes an allocated section?  I didn't think it necessarily appeared 
> in any of the PT_LOAD segments, because the linux/elfnote.h macros don't 
> necessarily set "a" on the section.

The earlier patches in this series change the linker script to place it
appropriately and set the phdr.  It's allocated when its input sections are
allocated.  Current builds I've seen don't have any input note sections at
all.  My motivation is for the ld --build-id support, which generates an
allocated note section as if it were input.

> I have a patch to always do this, and also convert all the note 
> generation to C code rather than asm.  If your patch works for you, 
> however, it should be completely orthogonal.

What note generation do you mean?  The only explicit notes in asm that I
know of are in the vDSO images, not in vmlinux.  This patch has nothing to
do with any vDSO image's generation.


Thanks,
Roland
