Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXGWGVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXGWGVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXGWGVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:21:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57553 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbXGWGVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:21:11 -0400
Date: Mon, 23 Jul 2007 08:22:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: David Miller <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723062224.GA3933@uranus.ravnborg.org>
References: <20070722.012321.79430375.davem@davemloft.net> <20070723060155.2B3824D0489@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723060155.2B3824D0489@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 11:01:55PM -0700, Roland McGrath wrote:
> It turns out the problem here is that some .o files wind up with their own
> .note.gnu.build-id sections.  I got the makefile magic wrong, thinking that
> LDFLAGS_MODULE was a variable specifically for .ko links.

Reading Documentation/kbuild/makefiles.txt:
LDFLAGS_MODULE      Options for $(LD) when linking modules

        LDFLAGS_MODULE is used to set specific flags for $(LD) when
        linking the .ko files used for modules.

So it seems to be documented as such.

Browsing the source it looks like a bug that LDFLAGS_MODULE is used in
cmd_link_multi-m.
I suggest you to do the following:
Remove '-r' from LDFLAGS_MODULE in top-level Makefile
Hardcode '-r' in cmd_link_multi-m and remove LDFLAGS_MODULE in the same.
Hardcode '-r' in Makefile,modpost
Add your stuff to LDFLAGS_MODULE in toplevel Makefile.

Sorry for not prrviding a preliminary patch but away from my dev box
with no easy source access.

	Sam
