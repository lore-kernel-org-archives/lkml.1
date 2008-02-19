Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYBSQHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYBSQHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYBSQHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:07:41 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:40474 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYBSQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:07:40 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Date: Tue, 19 Feb 2008 11:04:49 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <200802191006.50693.chris.mason@oracle.com> <47BAF3FF.3070300@wpkg.org>
In-Reply-To: <47BAF3FF.3070300@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191104.49482.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Tomasz Chmielewski wrote:
> Chris Mason schrieb:
> > On Tuesday 19 February 2008, Tomasz Chmielewski wrote:
> >> Theodore Tso schrieb:
> >>
> >> (...)
> >>
> >>> The following ld_preload can help in some cases.  Mutt has this hack
> >>> encoded in for maildir directories, which helps.
> >>
> >> It doesn't work very reliable for me.
> >>
> >> For some reason, it hangs for me sometimes (doesn't remove any files, rm
> >> -rf just stalls), or segfaults.
> >
> > You can go the low-tech route (assuming your file names don't have spaces
> > in them)
> >
> > find . -printf "%i %p\n" | sort -n | awk '{print $2}' | xargs rm
>
> Why should it make a difference?

It does something similar to Ted's ld preload, sorting the results from 
readdir by inode number before using them.  You will still seek quite a lot 
between the directory entries, but operations on the files themselves will go 
in a much more optimal order.  It might help.

>
> Does "find" find filenames/paths faster than "rm -r"?
>
> Or is "find once/remove once" faster than "find files/rm files/find
> files/rm files/...", which I suppose "rm -r" does?

rm -r does removes things in the order that readdir returns.  In your hard 
linked tree (on almost any FS), this will be very random.  The sorting is 
probably the best you can do from userland to optimize the ordering.

-chris

