Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYEEXCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYEEXCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYEEXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:01:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbYEEXBv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:01:51 -0400
Date: Mon, 5 May 2008 16:00:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: w@1wt.eu, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Fix VT canonical input in UTF-8 mode [Was: UTF-8 fixes in
 comments]
Message-Id: <20080505160044.dcc36a51.akpm@linux-foundation.org>
In-Reply-To: <20080504102554.GA4729@implementation>
References: <20080430000851.GH4818@implementation>
	<20080430194920.GD7501@1wt.eu>
	<20080503235027.GO8032@implementation>
	<20080504085514.GA27263@1wt.eu>
	<20080430000851.GH4818@implementation>
	<20080430194920.GD7501@1wt.eu>
	<20080503235027.GO8032@implementation>
	<20080504102554.GA4729@implementation>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 11:25:54 +0100
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Samuel Thibault, le Sun 04 May 2008 00:50:27 +0100, a écrit :
> > Willy Tarreau, le Wed 30 Apr 2008 21:49:20 +0200, a écrit :
> > > On Wed, Apr 30, 2008 at 01:08:51AM +0100, Samuel Thibault wrote:
> > > > Willy Tarreau wrote:
> > > > > 3) if I enter Alt-196, I get a "Ä". Flushing the buffer shows that od
> > > > > got two bytes: c3 84.
> > > > 
> > > > Confirmed.
> > > > 
> > > > Try init=/bin/stty -a, that will show
> > > > 
> > > > -iutf8
> > > > 
> > > > So there is little wonder that canonical mode does not work as expected.
> > > > 
> > > > Try init=/bin/sh, from that shell run stty iutf8. Then things will work
> > > > fine.  The fix is thus just to make the VT's tty initial iutf8 setup
> > > > follow vt.default_utf8.
> > > 
> > > Will try that on a more recent install. Mine's stty does not support
> > > this option. Your analysis makes quite a lot of sense, and such a fix
> > > would wipe part of my annoyances/anger with this recent change.
> > 
> > Can you give the patch below a try?
> > Dynamic per-VT utf-8 switch should also work, provided that you reopen
> > the VT (i.e. log out).
> 
> Willy Tarreau, le Sun 04 May 2008 10:55:14 +0200, a écrit :
> > I confirm that your patch works perfectly for me. Now backspace correctly
> > removes multi-byte characters. My bash is still fooled though but as Alan
> > explained it, it's readline which has to be upgraded now.
> 
> I guess this is suitable for the stable trees of 2.6.24 and 2.6.25
> (where UTF-8 is by default now).
> 
> 
> 
> 
> Set IUTF8 as appropriate on VT tty open.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

That changelog is pretty darn terse :(  I'll often go through
the email ladder and try to extract the missing information
but this time I don't really see it there.

Things like: what is the kernel's current behaviour, why does
it behave that way, how does the patch fix it?

Thanks.
