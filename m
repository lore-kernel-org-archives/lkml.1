Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbXIXIJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbXIXIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXIXIJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:09:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIXIJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:09:52 -0400
Date: Mon, 24 Sep 2007 09:09:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Move kasprintf.o to obj-y
Message-ID: <20070924080948.GA8525@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@sw.ru>,
	akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
References: <20070924071826.GA6757@localhost.sw.ru> <20070924074110.GA7721@infradead.org> <20070924075949.GA1742@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924075949.GA1742@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:59:49AM +0200, Sam Ravnborg wrote:
> > Please kill lib-y while you're at it.  It's useless and a constant
> > source of pain like this.
> Kernel-bloat is another "constant source of pain".
> But the troubles are that increased blot does not result in compiler erros.
> 
> And your proposal to kil lib-y is a counter-act here.

Killing lib-y doesn't create kernel bloat if done right.  Just introduce
proper Kconfig dependencies for the truely optional parts.  But if you
look at the list of objects in lib-y you'll see that they fall in basically
three categories:

 (1) always used by core code - should be obj-y
 (2) generic implementation for arch-specific functionality, should be
     guarded by Kconfig for clarity reasons anyway
 (3) library code often but not always used by code that's not always
     built in.  Here we run into the move to obj-y to avoid compiler
     warning when used as module issue all the time.  Adding a CONFIG
     for the bigger onces actually avoids bloat over obj-y here, and
     when it's small enough obj-y is a lot safer in the presence of
     modular users

Really, trying to use the old static library use on demand concept simply
doesn't fit the way the kernel is built with it's modules and dependencies.
