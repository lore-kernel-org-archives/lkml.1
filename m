Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbXFDJAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbXFDJAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXFDJAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:00:21 -0400
Received: from lazybastard.de ([212.112.238.170]:59536 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbXFDJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:00:19 -0400
Date: Mon, 4 Jun 2007 10:54:48 +0200
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
Subject: Re: [Patch 06/18] fs/logfs/compr.c
Message-ID: <20070604085447.GA14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184355.GG8952@lazybastard.org> <200706032358.44870.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706032358.44870.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 June 2007 23:58:43 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +#define COMPR_LEVEL 3
> > +
> > +static DEFINE_MUTEX(compr_mutex);
> > +static struct z_stream_s stream;
> 
> Is there a particular reason to choose '3' as the only compression
> level? Should this perhaps be a per-superblock option instead?

There is no particular reason.  '3' should be a reasonable value for
most people.  If actual users want to change this value, I can make it a
mount option as well.  Right now I'm just lazy and doubt the merits.

> Also, I thought I saw discussion about making the mutex and
> stream per-superblock, but don't remember if the idea was discarded.
> If it was, you might want to add it to the won't-happen list.

It was more or less discarded.  As long as the sweet spot for LogFS is
small systems, saving memory is more important than multithreaded
performance.  Will add it to the list.

Jörn

-- 
Joern's library part 2:
http://www.art.net/~hopkins/Don/unix-haters/tirix/embarrassing-memo.html
