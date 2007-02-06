Return-Path: <linux-kernel-owner+w=401wt.eu-S1030557AbXBFXMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030557AbXBFXMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030559AbXBFXMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:12:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38500 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030557AbXBFXMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:12:03 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 Feb 2007 23:11:55 +0000
Message-Id: <1170803515.29759.1032.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 14:53 -0800, Linus Torvalds wrote:
> I don't think you've ever showed any such example.
> 
> And if you did, it would all boil down to *exactly* what 'select' does: 
> config options that get set automatically based on other choices.

That's one option which I don't think I've seen implemented.

The other possibility which comes to mind, and which I _have_ seen
implemented, is not to hide the disabled option but to _show_ it, and
represent its dependencies right there next to it somehow. 

Where I saw this done was actually in the Nemesis kernel configuration,
which was based on our old tcl xconfig tool. It actually worked quite
well. It's a _long_ time ago now, but IIRC it was in a cell below the
disabled option. It'd look something like (remember hte old xconfig?):

------------------------------------------------------------------------
|  USB Mass storage support                      |  o Y   o M   ✓ N    |
------------------------------------------------------------------------
|  depends on:  o SCSI   ✓ USB                                         |
------------------------------------------------------------------------

I'm sure I had a screenshot of it once. But it doesn't matter; you get
the idea -- our current tools would do it differently anyway. But they
_could_ do it.

> So care to give a real example? Start with USB automatically selecting 
> SCSI support without the user having to even know it uses SCSI. Tell me 
> how it's supposed to work sanely without 'select'.

Well one option, as you suggest, is just that if you go into the
graphical tool and enable USB_STORAGE, you get SCSI turned on
automatically. That's simple enough and the xconfig tool can do it quite
easily. It just needs to _show_ you the option, which isn't particularly
hard. But what I care about is that when you when you explicitly set
 # CONFIG_SCSI is not set
and run 'make oldconfig' it doesn't get turned back on again.

But as I said, I'm not entirely averse to having to do 'make
oldconfig-noselect' or something like that to preserve the old
behaviour. And then you can sprinkle 'select' wherever you like without
bothering those of us who object.

-- 
dwmw2

