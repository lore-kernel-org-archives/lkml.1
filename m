Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbXCFMp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbXCFMp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933243AbXCFMp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:45:57 -0500
Received: from village.ehouse.ru ([193.111.92.18]:1305 "EHLO mail.ehouse.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbXCFMp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:45:56 -0500
From: "Alexander Y. Fomichev" <gluk@php4.ru>
Reply-To: "Alexander Y. Fomichev" <gluk@php4.ru>
To: Bill Irwin <bill.irwin@oracle.com>
Subject: Re: kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
Date: Tue, 6 Mar 2007 15:45:23 +0300
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       admin@list.net.ru
References: <200703021651.16050.gluk@php4.ru> <20070302214111.GL10643@holomorphy.com>
In-Reply-To: <20070302214111.GL10643@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061545.23470.gluk@php4.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007, Bill Irwin wrote:
> On Fri, Mar 02, 2007 at 04:51:15PM +0300, Alexander Y. Fomichev wrote:
> > I'm hit a bug on 2.6.21-rc1 at startup of mysql with 'large-pages' flag
> > set. (at this point mysql trying to allocate pages from hugetlb pool by
> > sysv shm syscalls). Seems like it could be triggered by previous badness
> > and probably hugetlb itself is not related. Anyway i couldn't reproduce
> > it by now with 2.6.21-rc2 git commit
> > 562aa1d4c6a874373f9a48ac184f662fbbb06a04. Very likely it has been fixed
> > somwhere between 2.6.21-rc1 and -rc2, but i couldn't find something
> > related by git log so any comments are welcome.
>
> If you have a known-working kernel version, git-bisect might help you
> track down where it was introduced. Given the messages prior to the
> hugetlbpage.c BUG_ON I'd say that this is something else besides the
> specific code listed by line number, 

Nop, seems like it is hugetlb bug fixed by Adam 
commit 516dffdcd8827a40532798602830dfcfc672294c
[PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
I've disregard it thoughtlessly so Adam marks it specific for powerpc/ia64.
(hmm.. i donno realy why, huge pages should be alined anyway and if i 
understend it correctly it may not be if is_file_hugepages() fails)

As of "junk" just before the BUG this again IIUC because o-direct staff
catches this issue before hugetlb.

> though I wouldn't rule out hugetlb
> having tripped over itself before the actual BUG.
>

Yep, it is.

> -- wli


-- 
Best regards.
        Alexander Y. Fomichev <gluk@php4.ru>
        Public PGP key: http://sysadminday.org.ru/gluk.asc
