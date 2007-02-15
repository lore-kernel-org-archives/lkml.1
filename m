Return-Path: <linux-kernel-owner+w=401wt.eu-S965807AbXBOKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965807AbXBOKkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965822AbXBOKkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:40:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54682 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965807AbXBOKku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:40:50 -0500
Date: Thu, 15 Feb 2007 11:40:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?B?Uy7HYT8/bGFy?= Onur <caglar@pardus.org.tr>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
Message-ID: <20070215104032.GL26240@elf.ucw.cz>
References: <200702090838.21060.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702090838.21060.caglar@pardus.org.tr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> With 2.6.20, resuming from disk sometimes cannot returns on vt7 where X runs 
> but everything seems working, so just changing to vt1 and returning to vt7 
> solves the problem. But dmesg shows some BUG() output like [1] whenever this 
> problem occurs
> 
> I'm using 20070207 snapshot of suspend, s2disk is used to suspend2disk, 
> machine is a Sony Vaio FS-215B which is in the whitelist and works well with 
> 2.6.16/17/18 (all have fbsplash and vesafb-tng patches [from gentoo] 
> applied).
> 
> [1] http://cekirdek.pardus.org.tr/~caglar/dmesg.2.6.20

Contact fbcon people... They are calling do_blank_screen+0x4e/0x218
from fbcon_event_notify+0x8f1/0xa1e ... probably without taking
neccessary locks.

Aha, it seems their blanking code triggers _while_ resuming, which is
not exactly nice.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
