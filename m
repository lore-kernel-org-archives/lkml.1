Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbZJGHWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbZJGHWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZJGHWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:22:49 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:45509 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZJGHWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:22:49 -0400
Message-ID: <4ACC41A2.8070801@lumino.de>
Date: Wed, 07 Oct 2009 09:22:10 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
 energy
References: <20090923174820.GA12827@Krystal> <20091001144037.GB6205@linux.vnet.ibm.com> <20091004143745.GA19785@Krystal> <4AC99D55.8000102@lumino.de> <20091005125533.GA1857@Krystal>
In-Reply-To: <20091005125533.GA1857@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hrm, your assumption about the common case does not seem to fit my
> scenarios. 
Yep,

Obviously I was misled.

So I now understand that you want to schedule the thread as a result to
some event and the Thread might already be running at that time, so that
it does not need to enter an OS-based wait state.

But to me this looks as if a _counting_ semaphore is needed here (at
least in a more general case), instead of a binary semaphore (such as
FUTEX does manage). Only with a counting semaphore no events are missed
(unless the user software design cares for this with other means, which
might be difficult or impossible).

Of course the fast path of a  user space counting semaphore is easily
doable with atomic_inc() and atomic_dec().

But I only know about two working variants of the user space code for
the (binary) FUTEX. There seem to be some more implementations that do
not work decently.

I have no idea if it's possible to create a counting semaphore in user
space that uses the "futex" syscall (or whatever) for the case the
threads needs to wait.

-Michael

