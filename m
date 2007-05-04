Return-Path: <linux-kernel-owner+w=401wt.eu-S1422843AbXEDXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422843AbXEDXkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422782AbXEDXkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:40:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:9859 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422843AbXEDXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GuE55v2WTcUu3CM+7pQG5RRB+/vGDHUXTcusLWp5Aa4YzjCDs1hCbfClAsNN91ldvqxLYhc9LKbkRcoLGurldLuhVe50Aer2EZkK4Tvic4ffBAL1vTJVcRl7HcImlaY5DGWFxHjyebENs0JG7Il/8aiyZmL4ENotrsyTLBUwTvU=
Message-ID: <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
Date: Fri, 4 May 2007 16:38:21 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
	 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
	 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
	 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
	 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
	 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
	 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
	 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
	 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> This is a pretty specific case, that is not very typical to find in the
> usual common event loop dispatch application design.

This is where you are very wrong.  Yes, it's rare in the Unix world
because non-trivial programs cannot implement this in most cases with
the available infrastructure.  But it is very common in other places
and what is more, it makes a lot of sense.  It gives you scalability
with the size of the machines at no cost associated to reorganizing
the program.


> And if you *really* want your truly generic WaitForMultipleObjects
> implementation, your only way is to base it on files. Files are our almost
> perfect match to HANDLEs in our world. We have the basic infrastructure
> already there.

"basic", but not complete.  And I never said that the implementation
thye have is perfect, far from it.  The concept is good and if we now
can implement it, with all the event sources available, using an
efficient event delivery mechanism we are far ahead of their design.

The proposal now  on the table doesn't bring us there all the way and
it has the potential to make future work in the area of event delivery
harder just because there is more legacy code to be kept  happy.  This
is why I propose to not consider these changes and instead go for the
gold, i.e., the full solution.
