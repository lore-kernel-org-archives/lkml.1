Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYFIGXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYFIGXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYFIGW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:22:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48482 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822AbYFIGWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:22:55 -0400
Date: Mon, 9 Jun 2008 08:23:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080609062332.GA5622@uranus.ravnborg.org>
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

Accidentially I left an older hack in my patch:
+headers_check_all: headers_install headers_install_all
                    ^^^^^^^^^^^^^^^
+       $(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1


This made us install both to asm/ and asm-x86 (as this is an x86 box).

I will remove this hack before hitting kbuild-next.

	Sam
