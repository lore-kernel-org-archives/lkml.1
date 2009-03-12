Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZCLJ5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZCLJ5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZCLJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:56:57 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35144 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZCLJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:56:56 -0400
Date: Thu, 12 Mar 2009 10:58:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090312095854.GA9398@uranus.ravnborg.org>
References: <200903120437.03837.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120437.03837.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 04:37:03AM -0500, Rob Landley wrote:
> So I'm doing this:
> 
> make ARCH=m68k headers_install INSTALL_HDR_PATH=walrus
> 
> And it doesn't install unistd_mm.h which is included from asm/unistd.h.  (The 
> file is there in arch/m68k/include/asm/unistd_mm.h, it just doesn't get 
> installed.  So any code that #includes <asm/unistd.h> results in a file not 
> found error for the other one, which is essentially just a wrapper.)
> 
> I don't understand what the code's currently doing here well enough to fix it, 
> specifically where does this file list come from?  The file  
> arch/m68k/include/asm/Kbuild is adding "cachectl.h" to header-y, but there are 
> 31 files getting installed from that directory and only one in there.

Kbuild contains the following:

include include/asm-generic/Kbuild.asm
header-y += cachectl.h

And if you look up the content of "include/asm-generic/Kbuild.asm"
you will realize that this is a list of all the "always to be exported headers"
from any arch - so the list is consolidated in asm-generic.

The fix for m68k is to eiter:
1) unify unistd.h so we get rid of the _no.h and _mm.h variants
2) or add the _no.h and _mm.h files to Kbuild.

I recall that someone already did 1) and this is pending in m68k.git.
You could look in -next - I think it is fixed there.

	Sam
