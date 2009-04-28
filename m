Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZD1CzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZD1CzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZD1CzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:55:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbZD1CzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:55:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mundt <lethal@linux-sh.org>
X-Fcc: ~/Mail/linus
Cc: Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] arm: user_regset: iWMMXt in core dumps
In-Reply-To: Paul Mundt's message of  Tuesday, 28 April 2009 07:43:55 +0900 <20090427224355.GD5033@linux-sh.org>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
	<20090425001259.CDC92FC3C8@magilla.sf.frob.com>
	<20090427224355.GD5033@linux-sh.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090428025347.63D18FC3C6@magilla.sf.frob.com>
Date: Mon, 27 Apr 2009 19:53:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are these note definitions centrally defined anywhere? I looked at the
> include/elf/common.h in gdb, but it seemed fairly similar to linux/elf.h.

linux/elf.h constitutes the central place.  (And basically, de facto
everyone now seems to check with me for new ones.)  New user_regset types
all get the "LINUX" note name, so there is no real authority beyond the
kernel maintainers to harmonize with.

> Both sh and mips would benefit from a note type for DSP registers. Would
> something like an NT_PRDSPREG be accetable for this? Also, the note
> definitions seem to have hopped from 4 to 6, is there a definition for 5,
> or can that be used for a DSP register note type?

There is no particular benefit to packing the space.  It's just a 32-bit
identifier, with existing values assigned that are both large and small.
Please do not use any more small values.  They are used on other systems
that some tools already deal with, and it just keeps things simpler not to
add any new n_type values that are reused with different names on different
systems.  (I'll NAK any new use of values <= 20, which already have names
in glibc's elf.h.)

For a new purpose, it is my inclination to use a new NT_<machine>_<type>
name and pick a new value range, e.g. NT_SH_* at 0x300+n.  The
interpretation of these type codes is machine-specific, but it just seems
simpler to assign a new block of numbers to each machine and not have any
overlaps.

If you really mean a new particular note format that would actually match
across different machines, then a new generically-named type for that is
appropriate.  For that, I'd start with another new value range like 0x10000+n
(leaving the 0x?00+n blocks to be assigned for particular arch's).


Thanks,
Roland
