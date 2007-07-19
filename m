Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbXGSLTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbXGSLTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXGSLTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:19:07 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46713 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbXGSLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:19:06 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 07:17:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Karel Zak <kzak@redhat.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
In-Reply-To: <20070718223820.GF3181@petra.dvoda.cz>
Message-ID: <Pine.LNX.4.64.0707190715320.25024@localhost.localdomain>
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain>
 <469E7599.4060608@gmail.com> <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain>
 <20070718223820.GF3181@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Karel Zak wrote:

> On Wed, Jul 18, 2007 at 04:33:12PM -0400, Robert P. J. Day wrote:
> > On Wed, 18 Jul 2007, Jiri Slaby wrote:
> >
> > > Robert P. J. Day napsal(a):
> > > >   given that the entire contents of include/linux/tty.h is contained
> > > > within an "#ifdef __KERNEL__", it seems pointless to export it to
> > > > userspace, unless there's some kind of need for that header file to
> > > > exist in userspace, even if it's empty.
> > > >
> > > >   a quick grep shows that nothing under /usr/include references any
> > > > file of the name "tty.h" in any way.  thoughts?
> > >
> > > If we decide to remove the file, I would rather go through
> > > deprecation of the file with filing an entry in
> > > feature-remove-schedule. There still seems to be some users of the
> > > file.
> >
> > i'm curious -- how did you determine that?
>
>  $ grep "tty.h" util-linux/sys-utils/cytune.c
>  #include <linux/tty.h>
>
>  ... I'll fix it in util-linux-ng.

so you're saying you'll drop that include from util-linux, is that it?
but it's still a good plan to generate a warning whenever userspace
includes that file, so i'll submit a quick patch to generate that,
based on jiri's suggestion.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
