Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYJEAmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYJEAmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYJEAml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:42:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47156 "EHLO
	vinyl.outflux.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825AbYJEAml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:42:41 -0400
Date: Sat, 4 Oct 2008 17:42:33 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081005004233.GL10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net> <20081004145149.52c34ee7@infradead.org> <20081004220220.GK10632@outflux.net> <20081004164239.0c1483a4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004164239.0c1483a4@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 04:42:39PM -0700, Arjan van de Ven wrote:
> On Sat, 4 Oct 2008 15:02:20 -0700
> Kees Cook <kees.cook@canonical.com> wrote:
> > Nothing else seemed appropriate, but I could make a brand new proc
> > file, if that's sensible.  "status_private" ?
> 
> how about a file called "personality" that has each set bit as an ascii
> version ?
> (one per line maybe)

Well, it's a one-to-many due to how the personality types are defined,
so doing a bitfield-to-ASCII-names conversion wouldn't really work out:

        PER_SCOSVR3 =           0x0003 | STICKY_TIMEOUTS |
                                         WHOLE_SECONDS | SHORT_INODE,
        PER_OSR5 =              0x0003 | STICKY_TIMEOUTS | WHOLE_SECONDS,
...
        PER_BSD =               0x0006,
        PER_SUNOS =             0x0006 | STICKY_TIMEOUTS,

But I can certainly just make it a stand-alone file with just the
bitfield.  Or, I can still do the conversion and ignore PER_OSR5 and
PER_SUNOS.

-Kees

-- 
Kees Cook
Ubuntu Security Team
