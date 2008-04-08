Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYDHMa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYDHMa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 08:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYDHMaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 08:30:14 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58023 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYDHMaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 08:30:12 -0400
Date: Tue, 8 Apr 2008 15:35:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
Message-ID: <20080408113519.GA227@tv-sign.ru>
References: <20080329001230.D013726FA1D@magilla.localdomain> <20080329001341.7F93826FA1D@magilla.localdomain> <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, Linus, I'm sorry for being offtopic, but there is something
I can't understand from the very beginning, when TIF_RESTORE_SIGMASK
was introduced.

On 03/28, Linus Torvalds wrote:
> 
> On Fri, 28 Mar 2008, Roland McGrath wrote:
> >
> > Set TIF_SIGPENDING in set_restore_sigmask.  This lets arch code take
> > TIF_RESTORE_SIGMASK out of the set of bits that will be noticed on
> > return to user mode.  On some machines those bits are scarce, and we
> > can free this unneeded one up for other uses.
> 
> Hmm. That probably means that TIF_RESTORE_SIGMASK shouldn't be a "TIF" 
> flag at all,

Yes!

> but a "TS" ("thread status") flag.

Why do we need any flag? It looks a bit ugly. Isn't it better to introduce
the new magic ERESTART_XXX which means ERESTARTNOHAND + restore-sigmask ?

We only need this flag as an implicit parameter to the arch dependent do_signal()
which we can't call directly, and thus it must imply TIF_SIGPENDING, and it
is not valid after do_signal() (should be cleared). This all looks like
ERESTART_ magic, why should we add something else ?

See also http://marc.info/?l=linux-kernel&m=113734458516136

Of course, probably it is too late to change the implementation even if
I am right, the question is: what I am missed?

Oleg.

