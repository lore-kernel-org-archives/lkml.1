Return-Path: <linux-kernel-owner+w=401wt.eu-S965152AbXG0UPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbXG0UPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937809AbXG0UNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:13:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937806AbXG0UNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:13:40 -0400
Date: Fri, 27 Jul 2007 13:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070727131249.74330a3d.akpm@linux-foundation.org>
In-Reply-To: <200707272143.59551.mb@bu3sch.de>
References: <200707271857.24162.mb@bu3sch.de>
	<200707272130.48973.mb@bu3sch.de>
	<20070727123853.d16e875c.akpm@linux-foundation.org>
	<200707272143.59551.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 21:43:59 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > Sure, but why is the locking interruptible rather than plain old
> > mutex_lock()?
> 
> Hm, well. We hold this mutex for several seconds, as writing takes
> this long. So I simply thought it was worth allowing the waiter
> to interrupt here. If you say that's not an issue, I'll be happy
> to use mutex_lock() and reduce code complexity in this area.

So..  is that what the _interruptible() is for?  To allow an impatient user to ^c
a read?

If so, that sounds reasonable.  It's worth a comment explaining these decisions
to future readers, because it is hard to work out this sort of thinking just
from the bare C code.
