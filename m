Return-Path: <linux-kernel-owner+w=401wt.eu-S1767720AbXEDIPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767720AbXEDIPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767723AbXEDIPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:15:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58949 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767720AbXEDIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:14:59 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 04:14:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rewrite the MAJOR() macro as a call to imajor().
In-Reply-To: <Pine.LNX.4.61.0705041008180.18504@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705040410390.20834@localhost.localdomain>
References: <Pine.LNX.4.64.0704280621350.516@localhost.localdomain>
 <20070503231814.e12ad2d7.akpm@linux-foundation.org>
 <Pine.LNX.4.61.0705041008180.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Jan Engelhardt wrote:

>
> On May 3 2007 23:18, Andrew Morton wrote:
> >>  	struct inode *i = file->f_mapping->host;
> >>
> >> -	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
> >> +	return i && S_ISBLK(i->i_mode) && imajor(i) == LOOP_MAJOR;
> >>  }
> >
> >there's no runtime change, and I count a couple hundred MAJORs in the tree.
>
> Why do we even have imajor() if all it does is calling the MAJOR()
> macro?

  i'm guessing it's to hide the underlying implementation of
extracting the major/minor numbers from an inode, in case that
implementation ever changes, which strikes me as perfectly reasonable.
and i don't think you'd have any luck arguing that it should be
removed at this point:

$ grep -Erw "(imajor|iminor)" * | wc -l
350

  all i was doing was standardizing the small handful of holdouts.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
