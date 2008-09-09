Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYIIIoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYIIIoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYIIIoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:44:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYIIIob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:44:31 -0400
Date: Tue, 9 Sep 2008 01:43:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, quilt-dev@nongnu.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: mmotm 2008-09-08-18-32 uploaded
Message-Id: <20080909014354.764eb9ed.akpm@linux-foundation.org>
In-Reply-To: <20080909173753.c48a5ca7.kamezawa.hiroyu@jp.fujitsu.com>
References: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
	<20080909173753.c48a5ca7.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 17:37:53 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 08 Sep 2008 18:35:16 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-09-08-18-32 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc5:
> > 
> Hmm, I'm not sure this is a trouble or not..
> 
> ==
> %quilt push -a
> <snip>
> |commit 5ca7e4a6b0929c7a0763f9b2481e063d9f047db0
> |Author: Hans de Goede <j.w.r.degoede@hhs.nl>
> |Date:   Wed Sep 3 17:12:20 2008 -0300
> |
> |    V4L/DVB (8831): gspca: Resolve webcam conflicts between some drivers.
> |
> |    -remove USB-id's from zc0301 for cams for which zc0301.c does not support
> |      the sensor
> |    -remove USB-id's from sn9c102 for cams where sn9c102 does not support the
> |      bridge sensor combination
> |    -no longer make inclusion of usb id's removed from zc0301 and sn9c102
> |      conditional in gspca
> |    -fix conditional inclusion of USB-id's in gspca to also work when the
> |      conflicting drivers are build as a module
> |    -add a number of USB-id's to gspca from various windows .inf files:
> --------------------------
> No file to patch.  Skipping patch.
> patch: **** /tmp/po8iQmOc : No such file or directory
> Patch ../patches/linux-next.patch does not apply (enforce with -f)
> 
> This stop is caused by following line in changelog.
> 
>     c45:608f from generic sonix sn9c103 inf file (+ ov7630 which we support)
>     041e:4022 from creative webcam nx pro, same as already supported 041e:401e
>     0ac8:0301 from generic zc0301 driver which supports many sensors
>     10fd:804d from typhoon webshot driver (also FlyCAM-USB 300 plus)
> and this line .
>       converting those not to depend on consecutive minor numbers in commit
>   ->  5a6411b1178baf534aa9138052864dfa89d3eada and later when dev0 was added
> 
> When I added a charactor in front of the number, linux-next.patch is applied.
> Start from a number is bad ? (or my environment is bad ?)

urgh, that's patch(1) being silly and interpreting that text as part of
a patch.  IIRC it's interpreting it as a context diff.

Adding `-u' to the `patch' command will shut it up.  That change should
be made to quilt (IMO).  
