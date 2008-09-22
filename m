Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYIVUzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYIVUzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYIVUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:55:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYIVUz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:55:27 -0400
Date: Mon, 22 Sep 2008 13:54:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Januszewski" <michalj@gmail.com>
Cc: bonbons@linux-vserver.org, krzysztof.h1@poczta.fm,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: don't allow to set a video
 mode via vga= if FB doesn't support it
Message-Id: <20080922135438.c8a10da7.akpm@linux-foundation.org>
In-Reply-To: <5d9b736f0809221332q21dea0a1lb8159b64391ee978@mail.gmail.com>
References: <20080921210219.GC21215@spock.one.pl>
	<20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
	<20080922220054.4e74c099@neptune.home>
	<5d9b736f0809221332q21dea0a1lb8159b64391ee978@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 22:32:40 +0200
"Michal Januszewski" <michalj@gmail.com> wrote:

> On Mon, Sep 22, 2008 at 22:00, Bruno Pr__mont <bonbons@linux-vserver.org> wrote:
> 
> > This looks pretty much the same as what I requested some time ago:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=8062
> >
> > Would need to check -mm archives for the actual patch.
> >
> > Don't remember why it did not make it to mainline...
> 
> Well, the bug and the mm fix [1] are about a similar, yet slightly different
> issue than the one I'm trying to fix with my patch (note that the issue
> reported in the bug is currently fixed in the kernel, but the actual fix
> is differrent than the one in -mm due to x86 boot code refactoring
> that took place since then).
> 
> My patch fixes the case where the framebuffer is enabled, but none of
> the drivers support boot-time video mode setting, whereas the old
> patch fixed the case where it was possible to set a video mode even
> though the kernel didn't contain the framebuffer layer.
> 
> [1] http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/broken-out/fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
> 

OK.  It was merged into mainline but was later reverted by Linus:


commit 01e73be3c8f254ef19d787f9b6757468175267eb
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Tue May 8 20:12:30 2007 -0700

    Revert "fbdev: ignore VESA modes if framebuffer is disabled"
    
    This reverts commit 464bdd33e9baad9806c7adbd8dfc37081a55f27e.
    
    Peter Anvin correctly points out that VESA modes have nothing to do with
    frame buffers per se - they are often just regular extended text modes.
    Disabling them just because we don't have frame buffer support is very
    wrong.
    
    Cc: H. Peter Anvin <hpa@zytor.com>
    Cc: Antonino A. Daplas <adaplas@gmail.com>,
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

