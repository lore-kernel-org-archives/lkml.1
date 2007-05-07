Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbXEGFqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbXEGFqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXEGFqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:46:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:44856 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbXEGFqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ap+wtkv5+1AL74L62/sYW7TlZ67zDLN7gn0KOLZ5s1548Vv2b3YQ/Lj4k12usBqY91fm1GvUYxNnDxLqql+YFdlkOPYIwy93Tj5h2BB9gMXowp+BQJMiv1sk8MgyFeus8BMYrUA4se9QLAcLGBR0cgM1a/XKwOByMdMKs5oklDk=
Message-ID: <a36005b50705062246x21d8c3aah9db53b1e0bf4f79a@mail.gmail.com>
Date: Sun, 6 May 2007 22:46:02 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Davi Arnaut" <davi@haxent.com.br>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20070506125451.aac4b68f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
	 <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
	 <Pine.LNX.4.64.0705031433470.6502@alien.or.mcafeemobile.com>
	 <a36005b50705040828l28f1d039oe58224ff18286ecd@mail.gmail.com>
	 <Pine.LNX.4.64.0705041201390.6958@alien.or.mcafeemobile.com>
	 <a36005b50705041638h37cd0654q442e7d50f1e63040@mail.gmail.com>
	 <Pine.LNX.4.64.0705051118030.19104@alien.or.mcafeemobile.com>
	 <a36005b50705060050q512462edoe53efbc18f754471@mail.gmail.com>
	 <20070506125451.aac4b68f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> What is your position on the timerfd/signalfd/etc patches?

One more thing: recently in a network-related discussion with DaveM
et.al. we came across a situation where we want events from the
kernel.  The requirement is for fast event notification (or
non-blocking polling) and the event is only implicitly needed.  Having
a file descriptor open is not an option.  The possibilities are

- open a file in /proc or /sys or a socket for every call to te
function to check for events

- have a memory-mapped interface like kevent which does not keep file
descriptors open

File descriptions are problematic when it comes implicitly uses in the
runtime.  This is, for instance, why we have MAP_ANON instead of
keeping a /dev/null file descriptor open all the time.
