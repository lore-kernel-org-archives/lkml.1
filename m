Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZISJHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZISJHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZISJH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:07:28 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:40283 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbZISJH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:07:26 -0400
From: Jim Meyering <jim@meyering.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
In-Reply-To: <20090919103149.54258081@infradead.org> (Arjan van de Ven's
	message of "Sat, 19 Sep 2009 10:31:49 +0200")
References: <87vdjgqcbd.fsf@meyering.net> <20090918221658.GB28781@mit.edu>
	<87pr9npdlc.fsf@meyering.net> <20090919103149.54258081@infradead.org>
Date: Sat, 19 Sep 2009 11:07:21 +0200
Message-ID: <87k4zvpak6.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 19 Sep 2009 10:01:51 +0200
> Jim Meyering <jim@meyering.net> wrote:
>> Yeah, I mentioned I should do exactly that on IRC yesterday.
>> I've just run some tests, and see that at least with one SSD (OCZ
>> Summit 120GB), the 0.5s cost of sorting pays off handsomely with a
>> 12-x speed-up, saving 5.5 minutes, when removing a
>> 1-million-empty-file directory.
>>
>
> likely because you actually reduce the amount of IO; inodes share
> disk blocks; repeated unlinks in random order likely write the same
> block multiple times....

That makes sense.
Maybe cache effects, too?

> btw have you given thought about using threads as part of rm -r[f] ?
> (would make the unlinks of unrelated directories/files asynchronous)

While it is certainly a nicely parallelizable process,
rm usually runs so quickly that I doubt it'd be worthwhile.
If you know in advance that parallelizing a particular recursive
removal would give a significant benefit, it's probably best to do it
via e.g., xargs --max-procs=N.

However, sort *would* benefit, and some UCLA students implemented that
for a term project.  Unfortunately, the project is stalled because the
implementation was not efficient enough, and no one has found the
time to improve it since.
