Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYD2WPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYD2WPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYD2WPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:15:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:12928 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYD2WPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F9t4AvYMUSqJFbjcmv4e1zszjlWGmP9gsVvlQ5cfXrg6BG8VEMChGY38aW/948A10ydmrLkJUgimn11eIDCZ027SBp4eerwAgBvIx/mjl55l4fJQp7/Kc094nKDrbrdiisA+Q9xEKd1pC8M9h6nDf06GDgct/3OW1OCtD50H7wc=
Message-ID: <8bd0f97a0804291515l1d7aacaek34113003c955a3e@mail.gmail.com>
Date: Tue, 29 Apr 2008 18:15:01 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, willy@debian.org,
       viro@zeniv.linux.org.uk, uclinux-dist-devel@blackfin.uclinux.org,
       richterd@citi.umich.edu
In-Reply-To: <20080429221107.GH26468@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com>
	 <20080429135454.efebec8f.akpm@linux-foundation.org>
	 <20080429214231.GC26468@fieldses.org>
	 <8bd0f97a0804291501i2751d688h933508df2a4587b4@mail.gmail.com>
	 <20080429221107.GH26468@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 6:11 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Tue, Apr 29, 2008 at 06:01:47PM -0400, Mike Frysinger wrote:
>  > On Tue, Apr 29, 2008 at 5:42 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>  > >  The one thing I suspect is *not* a really serious problem here is the
>  > >  reported LTP failure, since probably the only user of this is Samba,
>  > >  which probably doesn't do a lot of tmpfs exports, and in any case it can
>  > >  probably soldier on (if with degraded performance--how badly I don't
>  > >  know) without getting the write lease it wants.
>  >
>  > i'm not sure i follow.  the reported problem is that file locking does
>  > not work on tmpfs/ramfs storage.  a not terribly uncommon scenario is
>  > to use tmpfs on /tmp (or similar location) and have file locking not
>  > work at all.  so programs that use file locking or scripts that
>  > leverage the flock utility from the util-linux package break.
>
>  There are three different mechanisms that might be called "file locks":
>
>         - fcntl() locks, aka "posix locks", "byte-range locks":
>           documented in the "Advisory locking" section of fcntl(2).
>         - flock() locks: documented in flock(2) This is what the shell
>           utility from util-linux uses.
>         - leases, documented in the "Leases" section of fcntl(2).
>
>  For the former two, I agree with you, applications actually depend on
>  them.
>
>  The bug report, however, is for leases, which are much less widely used.
>  (The only users I know of are Samba and, to a lesser extent, NFSv4
>  (which doesn't currently use write leases due to all these problems).)

ah sorry, you're right of course ... while i investigated the issue
originally, i clearly forget the details ;)
-mike
