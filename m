Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYDBGUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYDBGUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYDBGUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:20:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43082 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751628AbYDBGUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:20:10 -0400
Date: Wed, 2 Apr 2008 01:20:06 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpuset_scnprintf function
Message-Id: <20080402012006.1722c2bd.pj@sgi.com>
In-Reply-To: <20080401225422.064890000@polaris-admin.engr.sgi.com>
References: <20080401225422.064890000@polaris-admin.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm ... my apologies, Mike, if I overlooked some earlier discussion
of this patchset on one of the other more limited email threads that
we share ... however a couple of aspects of this patchset don't fit
so well for me.
 1) I'm surprised to see this new routine called 'cpuset_scnprintf'
    (with the "cpuset" prefix), rather than a variant of a trio of
    names with prefixes of bitmap_, cpumask_, and nodemask_, like
    the other print routines in the bitmap family.  This doesn't
    seem to be a cpuset function to me, but a bitmap (and derived
    types cpumask and nodemask) printing function.
 2) The idea of the patch, that being a kernel modal flag that if
    set, changes a few particular details of the kernel API for all,
    seems like something I'd rarely want to do, unless I was really
    short of other options.  It leads to one app breaking another
    as a result of changing this mode, and to head butting between
    apps which cannot agree on how to set the mode.  And it introduces
    the option of breaking an existing API, which is seldom a good
    option.

I tried reading the opening "discussion that led up" comments you
posted, but couldn't find any overwhelming problem that had to be
solved of sufficient magnitude and quandry of sufficient difficulty
to justify the API conflicts and breakage in (2) above.  I did find
this comment, apparently by Bert Wesarg (though that's not clear
from your presentation):

>  If you change the format, the brown-paper-bag is yours.

I don't see a compelling response to the above comment.

Granted, what you've done isn't outright changing the format.  Rather it
is handing user space a means to change the format system-wide.

However doing this is worse in my view than simply breaking the format
outright, unilaterally and irrevocably.  If you just flat out stick a
fork in an API and break it hard on some release, then at least user
space knows that it must adapt or die at that version.  If you hand
user space the means to break that API, then any properly and
defensively written user code has to be prepared to deal with both API
flavors, and the majority of user space code is broken half the time,
when run on a system with the API variant it wasn't expecting.  More
over, you end up with apps having "toilet seat wars" with each other:
you left it up and it should be down; no you left it down and it should
be up.  Not a pretty sight.

Perhaps I totally misunderstand this patchset ?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
