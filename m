Return-Path: <linux-kernel-owner+w=401wt.eu-S941385AbXHJTUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941385AbXHJTUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762545AbXHJTUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:20:38 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:39438 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbXHJTUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:20:37 -0400
Date: Fri, 10 Aug 2007 22:20:31 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070810192030.GB1916@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle> <46BC962B.9030209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BC962B.9030209@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 09:45:31AM -0700, H. Peter Anvin wrote:
> Let me get this straight... "edd=skipmbr" boots fine, but commenting out
> the call to query_edd() didn't?  Could you please try that (and, I
> guess, only that), and make sure everything necessary is rebuild.
>
> 2.6.23-*rc2* you say boots fine with "edd=skipmbr", but not without?

Yes, vanilla 2.6.23-rc2 with edd=skipmbr boots fine.

> Did you try the above commenting-out on rc2?

Yes, didn't work with 2.6.23-rc2 but printed one dot in the upper left
corner after grub stuff.

> Just don't want to be chasing ghosts.

I've bisected thus far, if it helps:

$ git-bisect log
git-bisect start
# good: [4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4]
# lots-of-architectures: enable arbitary speed tty support
git-bisect good 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4
# bad: [773208946a132fb733ba273ee8562814f828cc28] Revert "USB: fix
# gregkh-usb-usb-use-menuconfig-objects"
git-bisect bad 773208946a132fb733ba273ee8562814f828cc28
# bad: [dc690d8ef842b464f1c429a376ca16cb8dbee6ae] Merge
# master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
git-bisect bad dc690d8ef842b464f1c429a376ca16cb8dbee6ae

-Mikko
