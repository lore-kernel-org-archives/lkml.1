Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYDWQEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYDWQEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYDWQDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:03:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47594 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYDWQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:03:52 -0400
Date: Wed, 23 Apr 2008 10:03:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: Pull request for semaphore include changes
Message-ID: <20080423160348.GA29796@parisc-linux.org>
References: <20080419184029.GO20637@parisc-linux.org> <adawsmobm3f.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adawsmobm3f.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 08:57:24AM -0700, Roland Dreier wrote:
>  >  drivers/infiniband/core/user_mad.c            |    2 +-
> 
> Let me say up front I have no problem with this change, which moved from
> <asm/semaphore.h> to <linux/semaphore.h>.  So take this email as an
> honest question and not any form of complaint or criticism.  But looking
> at that user_mad.c file in particular, I don't see any use of anything
> that looks like it would come from semaphore.h.

You've missed this hunk:

        if (filp->f_flags & O_NONBLOCK) {
                if (down_trylock(&port->sm_sem)) {
                        ret = -EAGAIN;
                        goto fail;
                }
        } else {
                if (down_interruptible(&port->sm_sem)) {
                        ret = -ERESTARTSYS;
                        goto fail;
                }
        }

which is still in Linus' tree as of last night.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
