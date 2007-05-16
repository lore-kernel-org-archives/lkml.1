Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbXEPL1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbXEPL1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760902AbXEPL1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:27:39 -0400
Received: from lazybastard.de ([212.112.238.170]:39949 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbXEPL1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:27:38 -0400
Date: Wed, 16 May 2007 13:23:17 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516112317.GB5472@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org> <20070516052253.GI943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070516052253.GI943@1wt.eu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 07:22:54 +0200, Willy Tarreau wrote:
> 
> On hard disks, yes, but as you suggested, there are lots of other flash
> devices interfaced as block devices. CompactFlash comes to mind, USB
> keys too. And on these ones, the most important is to reduce the number
> of writes and to support large sizes. I already see LogFS as an interesting
> alternative to JFFS2 on such devices, eventhough it does not (yet?) support
> compression.

It does support compression now.  That part was finished, erm, about two
weeks ago.

Logfs on Smartmedia format (I assume most CompactFlash, USB, SD and MMC
media use that) will currently cause a nasty interaction.  Unlike JFFS2,
logfs will alternately write to several eraseblocks.  On real flash,
alternating between half-finished blocks is free.

Smartmedia standard requires to finish the last block before moving to
the next.  So the logfs write pattern will cause it to add an
erase/write overhead of - depending on erase size and compression - 4x
to 512x.  Pretty bad.

If Smartmedia was really stupid, there would be no overhead at all.  Any
manucaturers listening should seriously think about allowing raw flash
access to their devices. ;)

Jörn

-- 
To recognize individual spam features you have to try to get into the
mind of the spammer, and frankly I want to spend as little time inside
the minds of spammers as possible.
-- Paul Graham
