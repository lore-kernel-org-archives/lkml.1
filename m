Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbXEFHut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbXEFHut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXEFHut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:50:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:43206 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbXEFHus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lOvNqXBWpQMjj1Vg9nYD2EEoJnigWgHLn8DHQcOxDIQo0RL5c1vKPW8upLwQYw9JBnX0wqTjDX++fMWcjkfGyjGmBsrKh/jzSVJGxY8ll/d3TgFbDVN+ixxhcjCuzd0s8Cgk0MK0eICE/Abz7jyuh2gcav8p8QUHk4uM0TFxHv8=
Message-ID: <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
Date: Sun, 6 May 2007 00:50:47 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
	 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
	 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
	 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
	 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
	 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
	 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
	 <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
	 <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> But we have our own *sane* version of WaitForMultipleObjects, and it's
> called poll(2).

No, we don't.  Don't start all over again.  The interface of poll it
to primitive.  See the kevent code, each record is, IIRC, 16 bytes in
size to return more data.  For poll you only have bits.


> Now, considering that POSIX is the backbone of Linux (and *nix in
> general), and considering that we certainly cannot drop existing POSIX
> semantics, where the lagacy code will come from?

The legacy part comes from all this extra "make into a file
descriptor" stuff which is new, not needed now and especially not when
a full solution is available.


> I really do not understand your point. You're too smart to not appreciate
> the beauty and the simmetry of objects that responds to a common interface
> (our files, win32 handles), and that fits our existing kernel infrastructure.

You're blinded by this symmetry.  Not everything that looks like a
good fit is a good idea.  This is one case.  Get over it, poll is not
powerful enough to serve as the unifying event mechanism.
