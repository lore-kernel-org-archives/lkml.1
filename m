Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZEGHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZEGHoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbZEGHn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:43:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51571 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739AbZEGHn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:43:58 -0400
Date: Thu, 7 May 2009 09:40:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090507074003.GA17688@redhat.com>
References: <20090506053324.GA31988@redhat.com> <20090506200949.4FF6CFC39E@magilla.sf.frob.com> <20090507064559.GC15220@redhat.com> <20090507072003.8E0ACFC39E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507072003.8E0ACFC39E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07, Roland McGrath wrote:
>
> > Yes, I considered this option too. But since (I hope) you do not have
> > a strong opinion on this, I'd prefer to keep the code as is. This way
> > do_wait() looks more symmetrical wrt to other helpers. And we don't
> > copy args twice.
>
> I don't feel strongly.  But I do think that those two repeated assignment
> blocks are more to read and harder to read, and more error-prone for drift
> in future changes (vs prototype changes getting quick compilation errors).
> do_wait() is not "another helper", it's the main function.

I must admit, I do not agree. I feel the opposite. Yes we have 2 repeated
assignment blocks, but there are not exactly equal, and imho the difference
is more visible this way.

That said. This is not the technical issue, I can't "prove" I am right and
of course I may be wrong. I think we should follow the "maintaner is always
right" rule ;)

I'll send this change as another cleanup on top of the new series.

OK ?

> On machines
> with 6 argument registers (everything but x86-32?), the compiler probably
> does fine making the callers' register shuffling be free.  On x86-32, a few
> cache-hot stack stores and loads are in the tiny noise vs the whole cost of
> this hairy syscall, and IMHO don't compare to source maintainability issues.

Yes, I agree.

Oleg.

