Return-Path: <linux-kernel-owner+w=401wt.eu-S965711AbXDBTMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711AbXDBTMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965710AbXDBTMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:12:54 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:36981 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965711AbXDBTMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:12:53 -0400
Date: Mon, 2 Apr 2007 21:10:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
In-Reply-To: <46110F88.5040905@gmail.com>
Message-ID: <Pine.LNX.4.61.0704022108190.17673@yvahk01.tjqt.qr>
References: <46110F88.5040905@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 22:13, Antonino A. Daplas wrote:
>Resetting the console, either by ANSI escape sequences or by the reset utility,
>will drop the console back to legacy (non-UTF-8) mode. Fix this by leaving the
>field vc_data.vc_utf untouched in reset_terminal(). In addition, a global
>variable (default_utf8) which defines system-wide UTF-8 setting is created.
>This variable can be adjusted via sysfs.
>
>This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.
>
>Signed-off-by: Antonino Daplas <adaplas@gmail.com>

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>


>---
>
> drivers/char/vt.c |    4 +++-
> 1 files changed, 3 insertions(+), 1 deletions(-)


BTW. Is it feasible to make utf8 the default (static int default_utf8 = 1)
or is that likely to break some installs?


> static int printable;		/* Is console ready for printing? */
>+static int default_utf8;
>+module_param(default_utf8, int, S_IRUGO | S_IWUSR);

It's probably just me, but I would have used an unsiged int.



Jan
-- 
