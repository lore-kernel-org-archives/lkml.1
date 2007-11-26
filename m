Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXKZLWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXKZLWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 06:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXKZLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 06:22:34 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53183 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXKZLWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 06:22:33 -0500
Date: Mon, 26 Nov 2007 06:20:34 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Joonwoo Park <joonwpark81@gmail.com>
cc: netdev@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] atm/ambassador: kmalloc + memset conversion to
 kzalloc
In-Reply-To: <b25c3fa70711260253we514310g2652d40440dc514e@mail.gmail.com>
Message-ID: <alpine.LFD.0.9999.0711260619580.10766@localhost.localdomain>
References: <007f01c8300b$1b89ac40$9c94fea9@jason>  <alpine.LFD.0.9999.0711260409110.551@localhost.localdomain>  <b25c3fa70711260223w5a15bb1bk4652b3ab8f05c40c@mail.gmail.com>  <alpine.LFD.0.9999.0711260523420.12603@localhost.localdomain>
 <b25c3fa70711260253we514310g2652d40440dc514e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Joonwoo Park wrote:

> 2007/11/26, Robert P. J. Day <rpjday@crashcourse.ca>:
> > i realized that.  but all you can say is that only amb_init() calls
> > setup_dev() *currently*.  when you're not looking, someone else might
> > (for whatever reason) call setup_dev() from elsewhere, and *that* call
> > might not zero that memory area.
> >
> > IMHO, the only safe transforms of kmalloc+memset -> kzalloc are those
> > in which the flow of control is unmistakable and invariant.  splitting
> > that across a function call seems like a dangerous thing to do.
> > (except, of course, in the case, where the kzalloc() is added inside
> > the function -- then all callers are entitled to simplify *their*
> > code.  but that's different.)
> >
> > in any event, i just thought i'd point it out.  if you're absolutely
> > sure there will never be another call to setup_dev() from somewhere
> > else, then, yes, it's safe.
> >
>
> I understood your opinions. and partially agree with you.
> But isn't it a unfounded fear?

i don't know, i just thought i'd mention it.  if no one thinks it's an
issue, it's certainly fine with me.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
