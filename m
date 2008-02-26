Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbYBZSSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbYBZSSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYBZSSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:18:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:62795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYBZSSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:18:06 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: epoll and shared fd's
To: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Pierre Habouzit <madcoder@debian.org>,
       lkml <linux-kernel@vger.kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Marc Lehmann <schmorp@schmorp.de>,
       David Schwartz <davids@webmaster.com>
Reply-To: 7eggert@gmx.de
Date: Tue, 26 Feb 2008 19:16:30 +0100
References: <9MZLT-1YO-33@gated-at.bofh.it> <9N6Ng-5tn-21@gated-at.bofh.it> <9P5WE-33i-11@gated-at.bofh.it> <9Pk9l-1KA-1@gated-at.bofh.it> <9PNNZ-b0-5@gated-at.bofh.it> <a19Lb-1F0-13@gated-at.bofh.it> <a19Lb-1F0-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX196grJp9A+f/de/1znFopYYexWrgzVaphr0RsU
 n5I/p9nmpd4FlZGsUMoMHOSnLd/0GVtoFeAiIbAOEFp7+H/WMl
 QoVLNflhCfVlfKwmhwUBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> a) I did a
> 
> s/internal kernel handle/open file description/
> 
> since that is the POSIX term for the internal handle.
> 
> b) It seems to me that you text doesn't quite make the point explicit
> enough.  I've tried to rewrite it; could you please check:
> 
>        A6     Yes, but be aware of the following point.  A  file
>               descriptor is a reference to an open file descrip-
>               tion (see  open(2)).   Whenever  a  descriptor  is
>               duplicated  via dup(2), dup2(2), fcntl(2) F_DUPFD,
>               or fork(2), a new file descriptor referring to the
>               same  open  file  description is created.  An open
>               file description continues to exist until all file
>               descriptors referring to it have been closed.  The
>               epoll  interface  automatically  removes  a   file
>               descriptor  from  an  epoll set only after all the
>               file descriptors referring to the underlying  open
>               file  handle  have  been  closed.  This means that
>               even after a file descriptor that is  part  of  an
>               epoll  set has been closed, events may be reported
>               for that file descriptor if other file descriptors
>               referring  to the same underlying file description
>               remain open.
> 
> Does that seem okay?  I plan to include the text in man-pages-2.79.

It's hard to read for me, and probably very hard to read for others.


