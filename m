Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZIEWq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZIEWq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 18:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZIEWqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 18:46:55 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44277 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZIEWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 18:46:54 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<19105.5352.28380.230615@pilspetsen.it.uu.se>
	<alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
	<87pra55nsr.fsf@devron.myhome.or.jp>
	<20090905225642.79251527@lxorguk.ukuu.org.uk>
Date: Sun, 06 Sep 2009 07:46:51 +0900
In-Reply-To: <20090905225642.79251527@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sat, 5 Sep 2009 22:56:42 +0100")
Message-ID: <87y6ot3t7o.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> So, it will use the 64kb limit at least few paths, and I'm not sure
>> though, non-n_tty path (e.g. ppp) doesn't use tty_write_room() check
>> always. It may not be consistent if we removed pty_space() in pty_write().
>
> The correct behaviour for most network protocols to overflow is to drop
> packets so the behaviour of not checking was intentional.

I see. I meant, ppp doesn't check (64kb) on write, but post-process(?)
checks (8kb). If there is this situation, I just worried it becomes the
cause of wrong behavior.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
