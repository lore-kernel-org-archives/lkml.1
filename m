Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYFHVM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYFHVM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYFHVMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:12:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53396 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYFHVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:12:50 -0400
Date: Sun, 8 Jun 2008 23:13:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608211331.GA32741@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <20080608200727.GA32141@uranus.ravnborg.org> <1212958734.2534.51.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212958734.2534.51.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 09:58:54PM +0100, David Woodhouse wrote:
> It doesn't look like headers_check_all will work after your patches --
> but to be fair I don't think it worked _before_ them either. When you
> run headers_install_all, there's no asm/ directory -- and thus the check
> will fail for any headers in linux/ which try to include <asm/*.h>. 
> 
> Did this _ever_ work?
It relied on what was installed in asm previously resulting in
arbitary failures - which confused me a little.

What I did in headers_check.pl was to introduce a second try.
If we see a #include <asm/file.h> then we try both of:
asm/file.h (first)
asm-$arch/file.h (if the asm/file.h did not succeed)

So with my version it actually works as expected and we
hit a bug in cris.
I've also implmented the feature that we stop on error so
when cris has a bug we do not try the rest.

It is both good and bad.

	Sam
