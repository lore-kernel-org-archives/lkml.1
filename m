Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYB1T1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYB1T1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbYB1T1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:27:47 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34433 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYB1T1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:27:46 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Feb 2008 11:27:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Valdis.Kletnieks@vt.edu
cc: 7eggert@gmx.de, Michael Kerrisk <mtk.manpages@googlemail.com>,
       Pierre Habouzit <madcoder@debian.org>,
       lkml <linux-kernel@vger.kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Marc Lehmann <schmorp@schmorp.de>,
       David Schwartz <davids@webmaster.com>
Subject: Re: epoll and shared fd's
In-Reply-To: <19752.1204206788@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0802281124330.7660@alien.or.mcafeemobile.com>
References: <9MZLT-1YO-33@gated-at.bofh.it> <9N6Ng-5tn-21@gated-at.bofh.it>
 <9P5WE-33i-11@gated-at.bofh.it> <9Pk9l-1KA-1@gated-at.bofh.it>
 <9PNNZ-b0-5@gated-at.bofh.it> <a19Lb-1F0-13@gated-at.bofh.it>
 <a19Lb-1F0-11@gated-at.bofh.it>            <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
 <19752.1204206788@turing-police.cc.vt.edu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Valdis.Kletnieks@vt.edu wrote:

> On Tue, 26 Feb 2008 19:16:30 +0100, Bodo Eggert said:
> > Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> 
> > >               file  handle  have  been  closed.  This means that
> > >               even after a file descriptor that is  part  of  an
> > >               epoll  set has been closed, events may be reported
> > >               for that file descriptor if other file descriptors
> > >               referring  to the same underlying file description
> > >               remain open.
> 
> Is it worth making special mention of the case where a process gets events
> for a FD that it has closed, because a parent or child process still has
> an inherited copy of the FD still open?

And for all the others, there's epoll_ctl(EPOLL_CTL_DEL) :)
The close(2) (f_op->release actually) hook is for cleanup semantics. If 
you play with multiple processes, just use epoll_ctl(EPOLL_CTL_DEL) and 
you'll be fine.



- Davide


