Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZD2HD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZD2HD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbZD2HDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:03:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbZD2HDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:03:17 -0400
Date: Wed, 29 Apr 2009 09:03:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
Message-ID: <20090429070316.GA3398@wotan.suse.de>
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org> <5622.1240628800@turing-police.cc.vt.edu> <20090425052434.GE10088@wotan.suse.de> <57773.1240857915@turing-police.cc.vt.edu> <20090428061557.GA29299@wotan.suse.de> <20954.1240934481@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20954.1240934481@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:01:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 28 Apr 2009 08:15:57 +0200, Nick Piggin said:
> 
> Here's the code (pretty much *all* the code):
> 
> > #include <linux/version.h>
> > #include <linux/utsname.h>
> > int main() {
> > 	if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
> > 		return 0;
> > 	} else {
> > 		return 1;
> > 	}
> > }
> 
> > Hmm, yes if you build without -O, then it appears like the compiler
> > trips over this. I wouldn't be unhappy with just removing the BUILD_BUG_ON,
> > but shouldn't the module be using -O[s2]?
> 
> It's a little autoconfig chunk from vendor code that determines if we're
> building on a sane/recent kernel.  Not the sort of thing you'd expect to
> need to invoke the frikking optimizer for program *correctness* :)

The kernel I think has for a long time required -O to compile correctly
because some things marked inline have had to be inlined for correctness.
This might have changed now that we have __always_inline, but anyway.

But I'll just get rid of that BUILD_BUG_ON.

Thanks,
Nick
