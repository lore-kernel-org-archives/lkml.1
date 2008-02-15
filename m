Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbYBOXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbYBOXaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762117AbYBOX3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:29:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57135 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761769AbYBOX3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:29:48 -0500
Date: Fri, 15 Feb 2008 23:23:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080215232308.GC31474@flint.arm.linux.org.uk>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
	arjan@infradead.org, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <20080212204813.GA21650@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212204813.GA21650@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:48:13PM -0800, Greg KH wrote:
> I have tried, and successfully done this many times in the past.  The
> kobject change was one example: add a new function, migrate all users of
> a direct pointer over to that function, after that work is all done and
> in, change the structure and do the needed work afterward.  All is
> bisectable completly, with no big "flag day" needed.

Incorrect - because this all happened far too quickly.  This is one of
the reasons that I ended up having to redo various parts of the ARM tree
because stuff broke - set_kset_name() completely vanished introducing
compile errors, and iirc some merge issues as well.

I had patches introducing new system objects which use that, and
modifications extremely close to other uses in the PXA code.

The end result (through rebuilding the affected parts of my git tree, and
asking people for replacement patches) was something that is bisectable -
but had I tried to merge stuff as is, it would've been an utter mess, and
_was_ unbuildable.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
