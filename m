Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYB1MKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYB1MKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbYB1MKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:10:46 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:2918 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbYB1MKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ix0qnDIgdWy9taBhmVigHjYEPEUoKzwrqVVSCfJC/dCZW2etMY1SOq8BsNf2asjLlZaEVOq7ur3W5CzSQGeWL4+tiIs77jQd3f4MpmGNqRgv5TDWSWUNYBcJ0kKw/35OmMxtndM4yYiGOgdFd4hYVSU4xumaXbnSRwTn1RPtqPc=
Message-ID: <cfd18e0f0802280410wccefb42ja66a2f4ee7513183@mail.gmail.com>
Date: Thu, 28 Feb 2008 13:10:44 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: 7eggert@gmx.de
Subject: Re: epoll and shared fd's
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Pierre Habouzit" <madcoder@debian.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Marc Lehmann" <schmorp@schmorp.de>,
       "David Schwartz" <davids@webmaster.com>
In-Reply-To: <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9MZLT-1YO-33@gated-at.bofh.it> <9N6Ng-5tn-21@gated-at.bofh.it>
	 <9P5WE-33i-11@gated-at.bofh.it> <9Pk9l-1KA-1@gated-at.bofh.it>
	 <9PNNZ-b0-5@gated-at.bofh.it> <a19Lb-1F0-13@gated-at.bofh.it>
	 <a19Lb-1F0-11@gated-at.bofh.it>
	 <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 7:16 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>  > a) I did a
>  >
>  > s/internal kernel handle/open file description/
>  >
>  > since that is the POSIX term for the internal handle.
>  >
>  > b) It seems to me that you text doesn't quite make the point explicit
>  > enough.  I've tried to rewrite it; could you please check:
>  >
>  >        A6     Yes, but be aware of the following point.  A  file
>  >               descriptor is a reference to an open file descrip-
>  >               tion (see  open(2)).   Whenever  a  descriptor  is
>  >               duplicated  via dup(2), dup2(2), fcntl(2) F_DUPFD,
>  >               or fork(2), a new file descriptor referring to the
>  >               same  open  file  description is created.  An open
>  >               file description continues to exist until all file
>  >               descriptors referring to it have been closed.  The
>  >               epoll  interface  automatically  removes  a   file
>  >               descriptor  from  an  epoll set only after all the
>  >               file descriptors referring to the underlying  open
>  >               file  handle  have  been  closed.  This means that
>  >               even after a file descriptor that is  part  of  an
>  >               epoll  set has been closed, events may be reported
>  >               for that file descriptor if other file descriptors
>  >               referring  to the same underlying file description
>  >               remain open.
>  >
>  > Does that seem okay?  I plan to include the text in man-pages-2.79.
>
>  It's hard to read for me, and probably very hard to read for others.

Bodo,

I'm just reviewing this text, trying to see if I can improve it.  At
the moment, I'm a little stuck.  can you say a little more about why
you find it hard to read?  that may help me improve it.

Cheers,

Michael


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
