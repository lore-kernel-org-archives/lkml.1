Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbZJGEgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbZJGEgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZJGEgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:36:49 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:39193 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZJGEgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tYfgLLpe3D4OCNAS+ypUFVB6RvZjS3iUh5Z0UEFxWI0StjGQRk4gAi7PcEuB/94565
         4kyGYDaYsFVF58dtV19ktki9oifF5mFS2G2LtzWQKRUr0trsTeDVfOzw1RGLhScMhE7a
         YHEBxblT+Ey1xVSLrWG1moiy7JqW4iZW/64Y4=
Date: Tue, 6 Oct 2009 21:36:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, linux-input@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 32-rc1 aka 32-rc2: warning at manage.c:361 (set_irq_wake),
	matrix-keypad related?
Message-ID: <20091007043603.GC10204@core.coreip.homeip.net>
References: <20090930200746.GA1384@ucw.cz> <20091006050649.GH27881@core.coreip.homeip.net> <20091006075816.GA1362@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006075816.GA1362@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 09:58:17AM +0200, Pavel Machek wrote:
> Hi!
> 
> On Mon 2009-10-05 22:06:50, Dmitry Torokhov wrote:
> > On Wed, Sep 30, 2009 at 10:07:46PM +0200, Pavel Machek wrote:
> > > 
> > > It complains about unbalanced irq 113 wake disable. That one belongs
> > > to matrix-keypad...
> > 
> > I guess some of enable_irq_wake()s fail on your box. Do you see it if
> > you apply the patch below?
> 
> I'll do short test. But... if you are right, your patch will just make
> your machine refuse to suspend... right?
> 
> Ungood.

It was just a debug patch.

> 
> Actually, it seems to break suspend (returns  -EINVAL while refusing
> to suspend), warnings are still there, and keyboard is dead after
> failed suspend... double plus ungood.
> 
> Aha, so warning is solved: the one in the log is from gpio_buttons.
> 

OK, so it looks like your box refuses to set up one of the GPIOs as a
wakeup source... Hmm, either your box is wrong ;) or matrix_keypad
driver needs to maintain a separate list of wakeup GPIOs.

-- 
Dmitry
