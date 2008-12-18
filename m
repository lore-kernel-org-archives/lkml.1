Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752977AbYLRJpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbYLRJpa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYLRJpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:45:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:52311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLRJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:45:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [4/7] dst: thread pool.
Date: Thu, 18 Dec 2008 10:44:27 +0100
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net> <1229561507.19360.0.camel@pasglop> <20081218081029.GA20336@ioremap.net>
In-Reply-To: <20081218081029.GA20336@ioremap.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181044.28157.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18WQOoGW9B0umRXtIIfZe6kfrBSB5pirZ9oZnU
 pWh8HTy51Vrdf3Gqrrb7C1/tlVKLqyjSVEmOSNvspq4YMM0OGB
 p3QsEiUDeKLZ5IBv71Hfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Evgeniy Polyakov wrote:

> That's how such projects are implemented: when developers need to
> extend some other sybsystem they do that with own implementation of the
> needed feature. Moreover people frequently argue against importing some
> new feature if there are no direct users of it (like may happen with
> thread pools, which no one will use immediately), so why bother with
> that crap (och, well, and interfaces, there will be definitely people
> who do not like them) when it is possible just to make working what
> you like? So I fully understand those who implemented it in theirs
> subsystems. I would even call blaming them for not pushing theirs
> implementations into generic location somewhat hypocritically because
> of above :)

I agree, and I don't think anyone has done anything wrong so far with
this. The natural way that internal features get into the kernel is
roughly:

1. Someone needs a feature and does a minimal implementation suiting
a specific purpose.
2. A few other people implement something similar, in slightly
different ways.
3. One of the implementations gets mentioned in a howto or a textbook
and people start copying from that.
4. One person gets fed up with the duplication and proposes a generic
solution as a patch.
5. After some discussion, this or another implementation gets merged.
6. The majority of the previous implementations get moved over to
the common code.
7. During that process, a deficiency in the interface gets noticed
and it gets changed again, forcing everyone who moved over to also
change again.

We are currently in stage 2, and I'm not sure if it's even a good idea
to skip any of the following stages. If we're lucky, we can skip stage 3.

	Arnd <><
