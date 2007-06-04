Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXFDJL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXFDJL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXFDJLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:11:51 -0400
Received: from lazybastard.de ([212.112.238.170]:54522 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXFDJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:11:50 -0400
Date: Mon, 4 Jun 2007 11:07:11 +0200
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
Subject: Re: [Patch 14/18] fs/logfs/segment.c
Message-ID: <20070604090711.GD14823@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184850.GO8952@lazybastard.org> <200706040021.43485.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706040021.43485.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 June 2007 00:21:41 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +static DEFINE_MUTEX(compr_mutex);
> > +
> 
> It seems you define a static compre_mutex in both segment.c and in compr.c,
> and always lock them both at the same time. Is that a correct observation?
> Is it intentional, or an oversight on your side?

Lame coding on my side.  Seems to have gone lost in my notes, but this
mutex should get removed and the protected memory made per-superblock.
Unlike the zlib workspace it does not consume 300k, so there is no
excuse for it here.

Jörn

-- 
Joern's library part 9:
http://www.scl.ameslab.gov/Publications/Gus/TwelveWays.html
