Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXIXI2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXIXI2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXIXI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:28:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37468 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXIXI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:28:14 -0400
Date: Mon, 24 Sep 2007 10:29:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Move kasprintf.o to obj-y
Message-ID: <20070924082940.GA1981@uranus.ravnborg.org>
References: <20070924071826.GA6757@localhost.sw.ru> <20070924074110.GA7721@infradead.org> <20070924075949.GA1742@uranus.ravnborg.org> <20070924080948.GA8525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924080948.GA8525@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:09:48AM +0100, Christoph Hellwig wrote:
> On Mon, Sep 24, 2007 at 09:59:49AM +0200, Sam Ravnborg wrote:
> > > Please kill lib-y while you're at it.  It's useless and a constant
> > > source of pain like this.
> > Kernel-bloat is another "constant source of pain".
> > But the troubles are that increased blot does not result in compiler erros.
> > 
> > And your proposal to kil lib-y is a counter-act here.
> 
> Killing lib-y doesn't create kernel bloat if done right.  Just introduce
> proper Kconfig dependencies for the truely optional parts.  But if you
> look at the list of objects in lib-y you'll see that they fall in basically
> three categories:
> 
>  (1) always used by core code - should be obj-y
>  (2) generic implementation for arch-specific functionality, should be
>      guarded by Kconfig for clarity reasons anyway
>  (3) library code often but not always used by code that's not always
>      built in.  Here we run into the move to obj-y to avoid compiler
>      warning when used as module issue all the time.  Adding a CONFIG
>      for the bigger onces actually avoids bloat over obj-y here, and
>      when it's small enough obj-y is a lot safer in the presence of
>      modular users
> 
> Really, trying to use the old static library use on demand concept simply
> doesn't fit the way the kernel is built with it's modules and dependencies.

I objected to just killing lib-y (the way I read your original proposal).
If we introduce proper kconfig dependencies as in (3) then I am all for it.

	Sam
