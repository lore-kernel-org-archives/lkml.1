Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZGFQAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZGFQAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZGFQAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:00:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZGFQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:00:09 -0400
Date: Mon, 6 Jul 2009 08:59:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ulrich Drepper <drepper@gmail.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [RFC PATCH] vfs: new open(2) flag to open filesystem node
In-Reply-To: <a36005b50907052250n7a73a19r3ce674f08a402703@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0907060858560.3210@localhost.localdomain>
References: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu> <2547.1246393535@redhat.com>  <E1MLruc-0007O1-Sp@pomaz-ex.szeredi.hu> <a36005b50907051235h17f559c6w1937998c7eec0b0@mail.gmail.com>  <alpine.LFD.2.01.0907051735030.3210@localhost.localdomain>
 <a36005b50907052250n7a73a19r3ce674f08a402703@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jul 2009, Ulrich Drepper wrote:

> On Sun, Jul 5, 2009 at 17:40, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
> > O_SEARCH is only meaningful for directories. For anything else, it's not
> > at all POSIX - it's expressly defined to be "undefined".
> 
> And this is why there is the differentiation with O_EXEC.  Yes, i
> didn't mention it in the last email.  But I mentioned it when it came
> up the first time.
> 
> I don't say this is indeed what is wanted/needed here.  But there are
> IMO some similarities and I think implementing O_SEARCH and O_EXEC is
> desirable.  If it means completely different implementations from te
> proposed O_NODE, so be it.  But my gut tells me there is some overlay.

I suspect that what we _could_ possibly do is to have something like 
O_NODE, and after that - if the semantics (for directories) match what 
O_SEARCH/O_EXEC wants, we could just do

	#define O_SEARCH O_NODE

but my point is that we should _not_ start from O_SEARCH and make that the 
"core" part, since its semantics are badly defined (undefined) to begin 
with.

Put another way: it's better to start with something that is well-defined 
(for us), and then say "in the special case of directories, this becomes 
the same thing as O_SEARCH", than start with something that is defined 
only for directories, and then say "ok, the behavior for other things is 
undefined, so we could hijack it for our own uses".

		Linus
