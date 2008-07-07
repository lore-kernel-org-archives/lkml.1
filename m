Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYGGGSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYGGGSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYGGGSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:18:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYGGGSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:18:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: benh@kernel.crashing.org
X-Fcc: ~/Mail/linus
Cc: Nathan Lynch <ntl@pobox.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
In-Reply-To: Benjamin Herrenschmidt's message of  Monday, 7 July 2008 15:48:13 +1000 <1215409693.8970.79.camel@pasglop>
References: <20080703234140.GC9594@localdomain>
	<20080704021929.5E9EF1541F5@magilla.localdomain>
	<1215409693.8970.79.camel@pasglop>
X-Zippy-Says: I want to so HAPPY, the VEINS in my neck STAND OUT!!
Message-Id: <20080707061811.19989154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 23:18:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, we use strings to represent the platforms already (ie, the actual
> CPU microarchitecture). Fitting those into bits would be annoying, it

Then use dsocaps.

> makes sense to have AT_BASE_PLATFORM to be the "base" variant of
> AT_PLATFORM.

I understand why you think so.  But let's not be too abstract.  The
purpose of the addition is to drive ld.so's selection of libraries, yes?

AT_PLATFORM is a lousy model.  Handling it is clunky in glibc, because
we have to compare against all the known strings to turn it back into a
bit for the ld.so.cache bitmasks.  We're not going to do the same for
AT_BASE_PLATFORM too, because it just sucks.

Using dsocaps gives you the best of both worlds.  You can freely choose
new strings in the kernel without the ld.so code having to know about
them (which is not true of AT_PLATFORM, but may be true of how you are
thinking about "strings are nice").  You do have to map all the
possibilities that a single kernel build can produce into distinct bits.
But, there are 32 unallocated bits to start with.  Moreover, those bit
assignments are not part of any permanent ABI like bits in AT_* values.
They just have to match up between this kernel build and the ld.conf.d
file installed along with it--kernel hackers and kernel packagers have
to coordinate, not kernel hackers and userland hackers.


Thanks,
Roland
