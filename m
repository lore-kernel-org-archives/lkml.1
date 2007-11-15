Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbXKOMTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbXKOMTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXKOMTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:19:35 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:3077 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbXKOMTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:19:35 -0500
Date: Thu, 15 Nov 2007 13:19:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Julia Lawall <julia@diku.dk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/i2c: Drop redundant includes of 
 moduleparam.h
Message-ID: <20071115131915.0eb34c98@hyperion.delvare>
In-Reply-To: <alpine.LFD.0.9999.0711140416160.4673@localhost.localdomain>
References: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk>
	<alpine.LFD.0.9999.0711131632490.26111@localhost.localdomain>
	<Pine.LNX.4.64.0711140707120.25487@ask.diku.dk>
	<alpine.LFD.0.9999.0711140416160.4673@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Wed, 14 Nov 2007 04:21:51 -0500 (EST), Robert P. J. Day wrote:
> On Wed, 14 Nov 2007, Julia Lawall wrote:
> 
> > > > From: Julia Lawall <julia@diku.dk>
> > > >
> > > > Drop #include <linux/moduleparam.h> in files that also include #include
> > > > <linux/module.h>.  module.h includes moduleparam.h already.
> > >
> > > i'm not convinced that's a good idea.  while module.h does
> > > currently (and unfortunately) include moduleparam.h, there may
> > > come a day when those header files are refactored to actually make
> > > sense, at which point all those missing moduleparam.h inclusions
> > > will cause all sorts of bad things to happen.

I share Robert's point of view here. Relying on header files including
each other is usually not a good idea, as build then breaks when the
headers are cleaned up or reorganized.

> > They were removed from the drivers/media files in August:
> > 9c12224a607a4b22ab86784e3394b52810b9507c
> > Perhaps they should be put back there then?
> 
> i went down this road before a few months back, checking on how many
> source files were unnecessarily including moduleparam.h, and the
> result was literally *hundreds*.  i took a shot at cleaning that up,
> and even factoring the non-parameter-related content out of that file,
> but the change would have been hugely disruptive.
> 
> as it is now, since module.h includes moduleparam.h, there is (as you
> can see) no reason whatever for *anyone* to include moduleparam.h.
> at least right now.
> 
> but if anyone ever aspires to tidy up this chaos, then all you'd end
> up doing is putting all those includes back in.  so unless there's a
> long-term goal here, it would seem safest to just leave things the way
> they are.  but that's someone else's decision, not mine.  i'm just
> reporting on how quickly things got unpleasant when *i* tried to do
> something with this once upon a time.

If there's a fundamental reason why module.h has to include
moduleparam.h, then both headers should be merged in a single file. If
not, then both header files should be clearly split and drivers should
include each of them as needed. Either way, header files must be fixed
first, and drivers adjusted in consequence. So, I'm not taking this
patch, sorry.

-- 
Jean Delvare
