Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXDFXDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXDFXDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbXDFXDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:03:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26290 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbXDFXDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:03:04 -0400
Date: Fri, 6 Apr 2007 16:03:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: handle spaces in array size
Message-Id: <20070406160335.e125e287.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr>
References: <20070406114730.02c82f43.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 21:24:48 +0200 (MEST) Jan Engelhardt wrote:

> On Apr 6 2007 11:47, Randy Dunlap wrote:
> >
> >Unfortunately, kernel-doc has problems with a struct field like this:
> >	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];
> >
> >simply due to the spaces around the "+" sign, so drop all spaces inside
> >[...] so that parsing is done correctly (in some sense).
> >

...

> 
> 	while($arg =~ s/\[(.*)\s+(.*)\]/[$1$2]/) {
> 	}
> 
> should do it, and saves us the pre-matching. (Also note the + at \s)
> (No need to escape [ and ] in the target pattern.)

Yep, that works.  Want to send it with sign-off or shall I just
send a new patch to akpm?

> I can also offer this gem which should do it the most saving way by
> matching the inside of [] exactly once, and otherwise
> matching/replacing only on \s:
> 
> 	$arg =~ s{\[(.*)\]}{($_=$1)=~s/\s+//g;"[$_]"}e;
> 
> (I already hear everyone screaming... ;-)

No, thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
