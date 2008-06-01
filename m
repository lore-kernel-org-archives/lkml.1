Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYFAVuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYFAVuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYFAVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:49:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYFAVtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:49:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Date: Sun, 1 Jun 2008 23:49:28 +0200
User-Agent: KMail/1.9.9
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
References: <200805311737.58991.arnd@arndb.de> <48421D65.8040301@lougher.demon.co.uk> <20080601122818.GA3687@shareable.org>
In-Reply-To: <20080601122818.GA3687@shareable.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806012349.29538.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/8EmGaoyP0rAS7PWYmLiWlAXGYzWyqHidfGbs
 EbF/YDyrSn2OjwhzqwI1LKU2yJ3Ni1Kt+90ry/1+rT7V3+Du39
 4FZmYW2o3PGiPPOqVUQ9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008, Jamie Lokier wrote:
> Ok, so why not fix that in unionfs?  An option so that holes in the
> overlay file let through data from the underlying file sounds like it
> would be generally useful, and quite easy to implement.

I can imagine a lot of unexpected effects with that. Think of e.g.
someone replacing the underlying file with a new one. Then enlarge
the file using truncate() and read from it -- suddenly you see
the old contents instead of zeroes. Probably fixable as well, but
certainly not in a nice way.

Besides, there are a many more problems with unionfs, which have
all been mentioned in the previous review cycles. Aufs doesn't
address those either AFAIK, with the exception of at least
not making additional copies in the page cache when writing to
a file.

The real solution of course are VFS based union mounts (think
'mount --union -t tmpfs none /'), but the patches for that
are not stable enough for inclusion in mainline yet.

> If not unionfs, a "union-tmpfs" combination would be good.  Many
> filesystems aren't well suited to being the overlay filesystem -
> adding to the implementation's complexity - but a modified tmpfs could
> be very well suited.

Yes, that is similar to one of my earlier ideas as well. Christoph
managed to convince me that it's not as easy as I thought, though
I can't remember the exact arguments any more. I'll try to think
about that some more.

One of the problems is certainly the complexity involved in tmpfs
to start with, which is the reason I based the code on ramfs instead.

	Arnd <><
