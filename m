Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYEQWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYEQWhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYEQWhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:37:15 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:52861 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYEQWhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:37:14 -0400
Date: Sun, 18 May 2008 00:36:40 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: hibernate event order question
Message-ID: <20080517223622.GA2668@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
References: <20080517175046.GA9032@yamamaya.is-a-geek.org> <200805172156.12686.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805172156.12686.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> > Now for my question:
> > AFAICS the ordering of events is as follows:
> > 1) User reqests hibernate
> > 2) Tasks are frozen
> > 3) Device suspend callbacks get called
> > 4) Device resume callbacks get called
> > 5) Memory image is written to disk
> 
> 6) Device suspend callbacks get called again to prepare for the system sleep
>    state.

According to my pci postcard this is not the case.
I modified nv_suspend to wiggle port 0x80 with mdelay(100) between
0xa0/0x50 wiggles and mdelay(1000) before returning, so it is easily
countable.
nv_suspend is called only once per ethernet port (step 3 above).
I have not yet tried adding a suspend_late handler.

> > In my case, I think the fix for the first bug (promiscous mode does
> > not get restored on resume) breaks wake-on-lan (since the new value
> > of NvRegPacketFilterFlags may be incompatible with wake-on-lan).

I reconfirmed this.  Without the promiscous mode bugfix,
wake-on-lan (partially) works.  With the promiscous mode bugfix the
machine doesn't wake up.  This is also easily explainable by 6) not
happening. :)

> > Shouldn't there be a 'prepare for poweroff'-callback, which gets
> > called
> > before the system is powered off for real?
> 
> Yes, it should and it's called in recent kernels.

For what values of 'recent'?
I'm running 2.6.26-rc2 here. :)
How do I hook into this callback?
(suspend_late maybe? Going to try that one next...)

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
