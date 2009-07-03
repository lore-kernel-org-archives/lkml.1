Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZGCB63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZGCB63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZGCB6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:58:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZGCB6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:58:19 -0400
Date: Fri, 3 Jul 2009 03:58:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <19021.24134.319252.776778@samba.org>
Message-ID: <alpine.LSU.2.00.0907030350330.24650@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <19021.17576.808138.476600@samba.org> <alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr> <19021.20449.732095.210252@samba.org> <alpine.LSU.2.00.0907030254180.22039@fbirervta.pbzchgretzou.qr> <19021.24134.319252.776778@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-03 03:26, tridge@samba.org wrote:
>
> > Making WINNT the default would cause many a `ls` output to just
> > scream at me in uppercaps because there are programs that
> > create long names with all-uppers.
>
>well, you could also argue that having WINNT in effect does the
>'correct' thing. It causes ls to display the name that is actually in
>the filesystem. 
>
>I think the current default for VFAT on Linux is rather misleading. It
>always displays 8.3 names as lowercase,

There is no misleading in that, since VFAT is rather case-insensitive.
Certainly, lowering all 8.3 names is more appalling to the eyes than
keeping all-caps-longnames that way. I think I would even add a new
heuristic for case transformation on display to fit my personal
guidelines which would be:

  ($file, $ext) = ($filename =~ /^(.*)\.(.*)$/);
  $ext = lc $ext;
  if ($file =~ /^[A-Z]+$/) {
      $file = lc $ext;
  }

I think none of the shortcase= options does that at this time.

>I should also point out that if we followed Alan's reasoning then we'd
>have to actually make all these options separate filesystems[...]

Linux has been doing case conversion all years long so I do not think
Alan's request to make new filesystems was based solely upon
shortname=; otherwise, I suspect, it would have raised it earlier.

