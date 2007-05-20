Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXETUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXETUIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXETUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:08:07 -0400
Received: from [216.16.235.2] ([216.16.235.2]:53630 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbXETUIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:08:06 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 20 May 2007 16:06:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h
 files.
In-Reply-To: <20070520191552.GA25200@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705201555470.18338@localhost.localdomain>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain>
 <20070520191552.GA25200@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Sam Ravnborg wrote:

> On Sun, May 20, 2007 at 03:06:15PM -0400, Robert P. J. Day wrote:
> >
> > In order to eventually break the interdependency between the module.h
> > and moduleparam.h header files, factor out the common MODULE_INFO
> > content into a new header file.
>
> The moduleinfo.h file looks redundant at first look. Why not push
> relevant parts from moduleparam.h (the MODULE_INFO bits) to module.h
> and let go of the include of moduleparam.h in module.h (when you
> have fixed the users)?
>
> In this way we do not add an extra .h file. And files that needs
> moduleparam.h will anyway always need module.h. But not the other
> way around.

crap, now i remember why i did it the way i did it.

yes, the way you describe it is a simpler solution, but it would break
all of the files in the tree that use module parameters and have
included *only* module.h, and have been getting away with it all this
time only because module.h currently includes moduleparam.h.

based on a simple script i have, there are currently 583 files under
the drivers/ directory *alone* that are like that.  that is, 583 files
that would need to include moduleparam.h instead of module.h simply to
continue to compile if the obvious header file fix were made.

in that situation, the proper (initial) patch would be one that

1) didn't break what was already there, and
2) allowed people to start cleaning up their files little by little

and when all of the cleanup was allegedly complete, the header files
could be adjusted to their final form.

is any of this making sense?  yes, sam's suggestion is clearly the
simpler one, but it can't be applied without cleaning everything up
*first*.  and without it, people can't start cleaning up code on their
own.

this *has* to be a two-step process.  you may not like the
moduleinfo.h file but think of it as a bridge to get to the final
result, when it can finally be thrown away.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
