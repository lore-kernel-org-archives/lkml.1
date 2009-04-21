Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZDURal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZDURal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbZDURaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:30:07 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:56352 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZDURaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:30:03 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="155393979"
Date: Tue, 21 Apr 2009 10:29:29 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421172929.GC8251@cuplxvomd02.corp.sa.net>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net> <1240333871.3632.70.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240333871.3632.70.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-5; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:11:11PM +0100, David Woodhouse wrote:
...
> The kernel output is going to be spewed when a console registers with
> CON_PRINTBUFFER anyway, and if we printk a warning about userspace
> console output being lost, that ought to be good enough to notify the
> user that something may have been lost. For bonus points, we could even
> make that 'dummy' tty driver buffer a limited amount of userspace
> output, maybe.

What in the world are users going to do when they see a message about
output being lost? There is no way to recover the data and no way to
prevent it in the future. I don't think this is a good approach.

Remember, even though the previous functionality of USB consoles was, in
theory, less reliable than it appeared, it actually has been working well
for years. Thus, tossing output will count as a regression for most of the
world.

> If userspace cares, let _it_ wait, by using an ioctl to see what tty
> device it's _really_ attached to.

I have a notion, perhaps misguided, that userspace *always* cares about
seeing all the output they have generated.

I have no objection to a userspace solution, in the long run, but such an
approach represents a significantly different approach to constructing boot
filesystems and we need a transitional period. In the interim, let's get
things working as they were.

> David Woodhouse                            Open Source Technology Centre

David VomLehn
