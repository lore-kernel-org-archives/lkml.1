Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbXFJTPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbXFJTPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbXFJTPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:15:07 -0400
Received: from lazybastard.de ([212.112.238.170]:46577 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbXFJTPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:15:05 -0400
Date: Sun, 10 Jun 2007 21:10:15 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 15/18] fs/logfs/super.c
Message-ID: <20070610191015.GC32619@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <200706101827.50948.arnd@arndb.de> <20070610173828.GA32619@lazybastard.org> <200706102033.11211.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706102033.11211.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 June 2007 20:33:05 +0200, Arnd Bergmann wrote:
> 
> Then maybe the submit_bio logic should only be done for the ->write
> path, not for ->read. The data that gets written out should already
> be present in the page cache for the files, so there is not much point
> having again, while you can see the read path as blockdev readahead:
> When you read a physical block that contains a logical block, it's
> likely to also contain part of another logical block that is going
> to be read in the near future.

Makes a lot of sense, yes.

> This way, you would also get exclusively clean pages in the block
> device address_space, which can be easily discarded.
> 
> Also, maintaining correct ordering between write requests can be
> done easier if you insert the bios directly, instead of waiting
> for the lru writeback.

s/easier/only/ ?

I don't think logfs on block devices makes too much sense yet, so my
personal priority for this is low.  Still, an obvious improvement.

Jörn

-- 
...one more straw can't possibly matter...
-- Kirby Bakken
