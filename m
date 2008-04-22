Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYDVXQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYDVXQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYDVXQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:16:25 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32901 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856AbYDVXQY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:16:24 -0400
Date: Wed, 23 Apr 2008 09:16:02 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: expose no-op xfs_put_perag()
Message-ID: <20080422231602.GZ108924158@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804221532.22701.vda.linux@googlemail.com> <200804221540.12382.vda.linux@googlemail.com> <200804221546.58136.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804221546.58136.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 03:46:58PM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> Inline function xfs_put_perag() in fs/xfs/xfs_mount.h is a no-op.
> 
> This patch converts it to no-op macro.

xfs_put_perag() is paired with xfs_get_perag() and should never be
called by itself. It is a stub for AG reference counting the
in-memory per-ag structures and, in future, locking to allow us to
avoid certain deadlocks that can occur (rarely) when growing and
shrinking the filesystem.

Also, I've got patches that put stuff in this function, so I'd
prefer to leave it as it is right now...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
