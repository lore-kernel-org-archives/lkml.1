Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZGOTQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZGOTQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZGOTQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:16:04 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:58611 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZGOTQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:16:03 -0400
Date: Wed, 15 Jul 2009 21:15:59 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: David Brownell <david-b@pacbell.net>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, David.Woodhouse@intel.com
Subject: Re: Kernel Oops when trying to suspend with ubifs mounted on
	block2mtd mtd device on 2.3.31-rc2
Message-ID: <20090715191558.GA18203@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	David Brownell <david-b@pacbell.net>,
	Adrian Hunter <adrian.hunter@nokia.com>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	David.Woodhouse@intel.com
References: <20090715122051.GA1439@yamamaya.is-a-geek.org> <4A5DD233.7090702@nokia.com> <200907151055.17959.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907151055.17959.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Wednesday 15 July 2009, Adrian Hunter wrote:
> > Looks like it might be related to MTD driver model updates.
> 
> Not the sysfs support ... more likely the patch adding cls_suspend()
> support, 15bce40cb3133bcc07d548013df97e4653d363c1, is goofed.  Maybe
> it's invoking suspend on the wrong device node...

Yes, that is the culprit.
AFAICS it uses the 'dev_to_mtd()' macro to get the mtd, but calls it
on itself instead of the child classes, so the resulting mtd device
pointer is bogus.

With some debug printks I get:

[...]
PM: Freed 0 kbytes in 0.06 seconds[...]
mtd_cls_suspend(f68e3180, 1)
dev->class->name = 'mtd'
callig mtd->suspend() [f68e3148]
BUG: unable to handle kernel paging request[...]
[...]

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
