Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXKNJZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXKNJZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXKNJZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:25:25 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:58124 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbXKNJZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:25:23 -0500
Date: Wed, 14 Nov 2007 04:21:51 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Julia Lawall <julia@diku.dk>
cc: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/i2c: Drop redundant includes of
 moduleparam.h
In-Reply-To: <Pine.LNX.4.64.0711140707120.25487@ask.diku.dk>
Message-ID: <alpine.LFD.0.9999.0711140416160.4673@localhost.localdomain>
References: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk> <alpine.LFD.0.9999.0711131632490.26111@localhost.localdomain> <Pine.LNX.4.64.0711140707120.25487@ask.diku.dk>
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

On Wed, 14 Nov 2007, Julia Lawall wrote:

> > > From: Julia Lawall <julia@diku.dk>
> > >
> > > Drop #include <linux/moduleparam.h> in files that also include #include
> > > <linux/module.h>.  module.h includes moduleparam.h already.
> >
> > i'm not convinced that's a good idea.  while module.h does
> > currently (and unfortunately) include moduleparam.h, there may
> > come a day when those header files are refactored to actually make
> > sense, at which point all those missing moduleparam.h inclusions
> > will cause all sorts of bad things to happen.
>
> They were removed from the drivers/media files in August:
> 9c12224a607a4b22ab86784e3394b52810b9507c
> Perhaps they should be put back there then?

i went down this road before a few months back, checking on how many
source files were unnecessarily including moduleparam.h, and the
result was literally *hundreds*.  i took a shot at cleaning that up,
and even factoring the non-parameter-related content out of that file,
but the change would have been hugely disruptive.

as it is now, since module.h includes moduleparam.h, there is (as you
can see) no reason whatever for *anyone* to include moduleparam.h.
at least right now.

but if anyone ever aspires to tidy up this chaos, then all you'd end
up doing is putting all those includes back in.  so unless there's a
long-term goal here, it would seem safest to just leave things the way
they are.  but that's someone else's decision, not mine.  i'm just
reporting on how quickly things got unpleasant when *i* tried to do
something with this once upon a time.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
