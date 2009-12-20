Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZLTOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZLTOFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZLTOFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:05:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:54543 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751527AbZLTOFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:05:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wl94ld6qwx4HgGA8qf2UMR3jKbSrBOJvU5WYIMF
	gQ40nczFivyk42
Subject: Re: [stable] Regression in 2.6.32.2: segfault on halt
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Holger =?ISO-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20091220130616.GC9719@1wt.eu>
References: <pan.2009.12.19.15.10.48.851500@googlemail.com>
	 <20091220054847.GF32739@1wt.eu> <4B2E10C6.7050304@googlemail.com>
	 <20091220130616.GC9719@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 15:05:38 +0100
Message-Id: <1261317938.6105.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 14:06 +0100, Willy Tarreau wrote:
> Hi Holger,
> 
> On Sun, Dec 20, 2009 at 12:55:50PM +0100, Holger Hoffstätte wrote:
> > Willy Tarreau wrote:
> > > On Sat, Dec 19, 2009 at 04:10:49PM +0100, Holger Hoffstaette wrote:
> > >> After updating to 2.6.32.2 last night (using same config from .32.1) I
> > >> noticed that "halt" now trips during shutdown and won't power the
> > >> machine down any longer. This happens reproducibly on two completely
> > >> different machines, so it looks like a generic problem and regression,
> > >> since it did not happen in .32.1. Note that "reboot" works as expected -
> > >> only "halt" crashes.
> > > 
> > > I have it working fine here. So your config helps to reproduce the issue.
> > > Care to post it ?
> > 
> > Attached, if it matters. However I managed to find some time with a spare
> > machine and always wanted to try bisect, so that's what I did - apparently
> > successfully:
> > 
> > root>git bisect bad
> > 37ed2d7007a65874850f3e357c095806c3756330 is the first bad commit
> > commit 37ed2d7007a65874850f3e357c095806c3756330
> > Author: Mike Galbraith <efault@gmx.de>
> > Date:   Wed Nov 4 17:53:50 2009 +0100
> > 
> >     sched: Rate-limit newidle
> 
> Interesting, because I saw this one too while digging the patch preview
> for the word "migration" which appeared in your trace. But these changes
> did not look suspicious (no obvious invalid pointer dereference for
> instance).
> 
> CCing Mike who may have an idea.

Thanks Willy.  No, no idea.  I can't see how this can possibly cause a
crash, but will try building with his config to see what happens.

	-Mike

