Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYGQIwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYGQIwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbYGQIwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:52:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbYGQIwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:52:08 -0400
Date: Thu, 17 Jul 2008 01:51:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
Message-Id: <20080717015105.f919f615.akpm@linux-foundation.org>
In-Reply-To: <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 00:25:41 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> This patch series introduces the "tracehook" interface layer of inlines
> in <linux/tracehook.h>.

Looks sane to me from a quick scan.

A ~200 byte increase in i386 allnoconfig .text is liveable with.  But
nothing defines CONFIG_HAVE_ARCH_TRACEHOOK yet.  What effect will that
have?

I don't like the name!  We have ftrace and we have static tracepoints
and we have dynamic tracepoints and we have linux trace toolkit and
whatever is in kernel/trace/trace.c etc, etc.  Now this work comes
along with _userspace_ tracing capabilities and it goes and calls it,
of all things, "trace"!

Things would be much less confusing were we to do s/trace/xyzzy/g on
the whole patchset.


Apart from that, I think the other big issue with this patchset is that
it doesn't do anything yet.  It's effectively a blank cheque.  There's
not a lot of point in merging all this work unless we also merge
something which uses it (is this correct?).  And afacit the thing which
will use it is utrace and utrace hasn't been sighted for a year or more
and it has met objections.

If we merge this and then utrace crashes on a rocky shore then there
was no (or little) point in having merged this.

Or am I wrong about that?  Does it have sufficient standalone value to
justify a standalone merge (yet alone to justify such a late merge)?
