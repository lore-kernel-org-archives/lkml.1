Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYHOIyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYHOIyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYHOIyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:54:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40522 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753011AbYHOIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:54:38 -0400
Date: Fri, 15 Aug 2008 09:35:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@suse.cz>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080815093513.5ca24c26@lxorguk.ukuu.org.uk>
In-Reply-To: <20080815004335.GF13048@mit.edu>
References: <20080813125638.GB6995@ucw.cz>
	<20080813135207.CC08C3765BC@pmx1.sophos.com>
	<20080814125410.GA2262@elf.ucw.cz>
	<2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
	<20080814223918.GC6370@elf.ucw.cz>
	<20080814200005.6b363716@bree.surriel.com>
	<20080815004335.GF13048@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So if that is the threat model, then the only thing libmalware.so
> doesn't solve is knfsd access, and it should be evaluated on that

And static binaries, and other kernel modular file I/O done on behalf of
applications, and making a library work well which is *hard*, and
labelling and scalability, and sharing a cache between users, and
aggregating events across processes .. and a few other things.

You have a lot of shared state here.

> So let's be real clear, up front, what the threat model is, and avoid
> changing the model around to rule out solutions that don't fit the
> initially preconceived one.  That's how you get to the TSA
> confiscating water bottles in airport security lines.

I don't think this is useful. I don't actually care what the virus folks
want to implement. I would rather see useful general purpose interfaces
that are practical and make sense. I cdon't really care whether people
use the write() system call to do sensible or dumb things. What we should
care about is the write syscall.

There seem so far to be two independent requests

* Noticing a file has recently changed, possibly with information about
changes and possibly being able to aggregate/time that for scalability.
This has a need to be able to accurately reference which file. This is
needed for good content indexing, and virus people want it for certain
kinds of scanning (post write, background etc). Doing this solely as a
final close notifier seems to be insufficient (as it may never close).

* Being able to pause an open pending some action. Examples include HSM
and dubiously some kinds of virus check. Problems here include the fact
it can only meaningfully be done for first open (which is fine for HSM)
and that the notion of an exclusive open, or of repeated clearly defined
open/read-write/close/done sequences are actually quite foreign to Unix
like systems.

We shouldn't need to care what people do with good interface. What
matters is in your airport example is that at the infrastructure level
there is a point you can choose to do scanning and we agree where.
Whether people use this to provide a Starbucks or goons with rubber
gloves who take away babies milk is an application layer problem.

Alan
