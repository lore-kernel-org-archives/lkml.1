Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbXGFHJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbXGFHJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761351AbXGFHI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:08:58 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:58019 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762434AbXGFHI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:08:56 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070705220444.GD3881@elf.ucw.cz> (message from Pavel Machek on
	Fri, 6 Jul 2007 00:04:44 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705220444.GD3881@elf.ucw.cz>
Message-Id: <E1I6huk-0003AH-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 09:07:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Actually fuse allows SIGKILL, because it's always fatal, and the
> > syscall may not be restarted.
> 
> Okay, and you should handle refrigerator in the same paths where you
> handle SIGKILL. Just add try_to_freeze() there...

It's the fourth time I'm repeating this in this thread:

Yes adding try_to_freeze() there would partially solve the probelem.

But another task can be sleeping on a mutex held by the task waiting
for the reply.  And the freezer won't be able to handle that one.

Generally, calling try_to_freeze() with mutexes held is not a good
idea.

Miklos
