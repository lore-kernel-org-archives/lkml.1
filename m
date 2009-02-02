Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZBBAcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZBBAcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 19:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZBBAcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 19:32:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZBBAcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 19:32:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
Date: Mon, 2 Feb 2009 01:31:02 +0100
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, mfasheh@suse.com,
       joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk,
       Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
References: <20090130171423.f99c88d0.akpm@linux-foundation.org> <20090201164130.GA32276@infradead.org> <4985D48A.6090007@panasas.com>
In-Reply-To: <4985D48A.6090007@panasas.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902020131.04203.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19LENEbkDPjcCPKkPgRuw92wJp7KyPZJX4FYT0
 g7mf4/RGEz0MTKetY1dOf//XL+bSE6kdc5DA+pddHfZPWHN4IU
 IcovClN3zwIa1x/tUy/6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 February 2009, Boaz Harrosh wrote:
> Christoph Hellwig wrote:
> > The structures have been defined exactly like that in XFS (and ocfs2)
> > before, and there are similar cases in other ioctls handlers.
> > 
> > If anyone feels like changing this in some way feel free to wade through
> > the endless discussions about the pros and cons for it, but I think
> > doing it in context of this patch is not helpful.
> 
> OK so ia64 gcc is broken in regard to __attribute__((packed(1))),
> and it should not be used.

No, the compiler is correct, it has to generate more complex code
if it cannot assume that data is naturally aligned and the architecture
does not support unaligned loads. If you don't understand this, please
at least read the list archives about the last five times this came up
before claiming that the compiler is broken.

> But clearly the programmer, Like in this patch exactly, should spell
> out the hole created by padding and spell that hole out and call it
> __Padding. The porgrammer thought about it, identified there is an hole,
> please don't drop this information on the floor. Put it in the code so I 
> don't have to break my head on it.

Again, you are missing the point. The patch has to leave out the padding
and whatnot because the idea of the patch is to provide a
backwards-compatible API for programs written against the legacy XFS
API. The original definition of the interface was flawed, but unless you
can travel back in time to complain about this in the initial submission
of the XFS file system, you should not blame the entirely correct patch now.

	Arnd <><
