Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXIWUgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXIWUgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXIWUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:36:37 -0400
Received: from barikada.upol.cz ([158.194.242.200]:49940 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbXIWUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:36:36 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Extend "memparse" to allow a NULL return pointer value.
In-Reply-To: <Pine.LNX.4.64.0709151217530.16440@localhost.localdomain>
References: <Pine.LNX.4.64.0709151217530.16440@localhost.localdomain>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sun, 23 Sep 2007 22:52:08 +0200
Message-Id: <E1IZYQy-0007zL-Us@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 15 Sep 2007 12:27:07 -0400 (EDT)

> Extend the memparse() routine to allow a caller to use NULL as the
> second parameter value if he has no interest in that returned value.

(not `he', but `it', even if `he', then better `callers' + `they')

> ---
>
>   there appear to be quite a number of calls to "memparse" which have
> no use for the value returned in the second parameter (the current
> pointer after the successful parse), but which are still forced to
> supply a valid char** address since they have no choice but to accept
> that value coming back.  in many cases, that value is accepted just
> before the end of the calling function, making it clear that the value
> is ignored entirely, anyway.

A posteriori value, stored in this pointer serves very important role: it
validates returned result. Caller must do this. But if programmer doesn't
know problems (see below), `must' melts down to `may'.

If you take a look at simple_strtoull(), it already doesn't care if this
pointer is NULL or not. (So patch is NULL :)

But take closer look. If it returns `0' (zero), it is not clear if this
zero was parsed or not, unless you can compare `ptr' and `retptr'.
Another case if entire string have no valid number to parse (see
strtol(3)).

This is problem of this particular function, that is copied form
ordinary C. For instance see <http://bugs.debian.org/431320>.
--
-o--=O`C
 #oo'L O
<___=E M
