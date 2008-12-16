Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759155AbYLPX1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYLPX1H (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYLPX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:26:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbYLPX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:26:52 -0500
Date: Tue, 16 Dec 2008 15:26:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: linux-next: Tree for December 16
Message-Id: <20081216152607.f232fafd.akpm@linux-foundation.org>
In-Reply-To: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 22:37:54 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)

This MTD patch:

commit 69423d99fc182a81f3c5db3eb5c140acc6fc64be
Author:     Adrian Hunter <ext-adrian.hunter@nokia.com>
AuthorDate: Wed Dec 10 13:37:21 2008 +0000
Commit:     David Woodhouse <David.Woodhouse@intel.com>
CommitDate: Wed Dec 10 13:37:21 2008 +0000

    [MTD] update internal API to support 64-bit device size

broke the i386 build:

ERROR: "__udivdi3" [drivers/mtd/devices/mtd_dataflash.ko] undefined!
ERROR: "__umoddi3" [drivers/mtd/devices/mtd_dataflash.ko] undefined!
ERROR: "__umoddi3" [drivers/mtd/devices/m25p80.ko] undefined!

because things like

                pageaddr = instr->addr / priv->page_size;

are now doing a 64-bit divide.

These will all need to be hunted down and converted to do_div().
