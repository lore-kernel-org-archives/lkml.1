Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZCJHh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZCJHh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZCJHhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:37:51 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56899 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZCJHhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:37:51 -0400
Date: Tue, 10 Mar 2009 16:33:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Oskar Schirmer <os@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <jw@emlix.com>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Mike Frysinger <vapier.adi@gmail.com>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
Message-ID: <20090310073350.GH10393@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Oskar Schirmer <os@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <jw@emlix.com>, David Howells <dhowells@redhat.com>,
	Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LfGwO-0007Kq-6c@mailer.emlix.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 06:00:59PM +0100, Oskar Schirmer wrote:
> The flat loader uses an architecture's flat_stack_align() to align the
> stack but assumes word-alignment is enough for the data sections.
> 
> However, on the Xtensa S6000 we have registers up to 128bit width
> which can be used from userspace and therefor need userspace stack and
> data-section alignment of at least this size.
> 
> This patch drops flat_stack_align() and uses the same alignment that
> is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
> not defined by the architecture.
> 
> It also fixes m32r which was obviously kaput, aligning an
> uninitialized stack entry instead of the stack pointer.
> 
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> Signed-off-by: Johannes Weiner <jw@emlix.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Bryan Wu <cooloney@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Mike Frysinger <vapier.adi@gmail.com>

The updated version looks ok to me anyways, and it's certainly an
improvement over defining the same alignment requirements all over the
place.

Acked-by: Paul Mundt <lethal@linux-sh.org>
