Return-Path: <linux-kernel-owner+w=401wt.eu-S933437AbXHKDmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbXHKDmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 23:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761380AbXHKDmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 23:42:39 -0400
Received: from ozlabs.org ([203.10.76.45]:46270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXHKDmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 23:42:36 -0400
Subject: Re: [PATCH 0/7] Modify lguest32 to make room for lguest64
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
In-Reply-To: <20070809003211.373543702@goodmis.org>
References: <20070809003211.373543702@goodmis.org>
Content-Type: text/plain
Date: Sat, 11 Aug 2007 13:42:04 +1000
Message-Id: <1186803724.30899.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 20:32 -0400, Steven Rostedt wrote:
> Hi all,
> 
> I've been working on lguest64 and in order to do this, I had to move
> a lot of the i386 specific out of the way.  Well, the lguest64 port
> is still not ready to display, but before Rusty makes too many changes
> I would like this in upstream so I don't have to keep repeating my
> changes :-)
> 
> 
> So this patch series moves lguest32 out of the way for other archs.

Yeah, after some more thought I've not applied most of this.  We really
don't want to move everything then move it back; I prefer Jes' more
cautious approach of moving a little bit at a time.

We really have three parts: (1) bits that are generic, (2) bits that
should be generic but my implementation is naive, (3) bits that really
are i386-specific.

Patches which move 2 to 1 are gratefully accepted: I realize a mass move
is easier and this requires thought, but that's what we need.

Since I can't build a module over two directories, that seems to destroy
the idea of an i386/ subdir.  Instead I've done a patch which renames
the *clearly* i386-specific things to i386_<name>, which at least works.
I've pushed it into the repository http://lguest.ozlabs.org/patches/

Cheers,
Rusty.

