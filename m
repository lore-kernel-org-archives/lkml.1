Return-Path: <linux-kernel-owner+w=401wt.eu-S1423019AbXBPB7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423019AbXBPB7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423023AbXBPB7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:59:45 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:60481 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423019AbXBPB7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:59:44 -0500
Date: Fri, 16 Feb 2007 01:59:34 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize generic get_unaligned / put_unaligned implementations.
Message-ID: <20070216015934.GB18987@linux-mips.org>
References: <20060306.203218.69025300.nemoto@toshiba-tops.co.jp> <20060306170552.0aab29c5.akpm@osdl.org> <20070214214226.GA17899@linux-mips.org> <20070214203903.8d013170.akpm@linux-foundation.org> <20070215143441.GA18155@linux-mips.org> <20070215135358.020781dd.akpm@linux-foundation.org> <20070215221839.GA14103@linux-mips.org> <20070215153823.239fd616.akpm@linux-foundation.org> <20070216004317.GA18987@linux-mips.org> <20070215172720.3e9ce464.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215172720.3e9ce464.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:27:20PM -0800, Andrew Morton wrote:

> No, icc surely supports attribute(packed).  My point is that we shouldn't
> rely upon the gcc info file for this, because other compilers can (or
> could) be used to build the kernel.
> 
> So it would be safer if the C spec said (or could be interpreted to say)
> "members of packed structures are always copied bytewise".  So then we
> can be reasonably confident that this change won't break the use of
> those compilers.
> 
> But then, I don't even know if any C standard says anything about packing.

Memory layout and alignment of structures and members are implementation
defined according to the C standard; the standard provides no means to
influence these.  So it takes a compiler extension such as gcc's
__attribute__().

> Ho hum.  Why are we talking about this, anyway?  Does the patch make the
> code faster?  Or just nicer?

Smaller binary and from looking at the disassembly a tad faster also.

  Ralf
