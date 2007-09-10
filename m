Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXIJOje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXIJOje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbXIJOj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:39:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:39275 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbXIJOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DCD9+RPWsiidXMaLnxR3142tznRPmFcT3t7BorZR1uLBKJq+ybz4ssljMtC9/9yV7KuYnD1rdwCoHPo0s6lyN3V+iB9eB87ew2wb4mS8g5PhX7I+SpE2u+pQHMr7bdbIOw0srkOwah7xWuPE7Nts1TA5oflBQkwTaBfWgblD7DU=
Message-ID: <6278d2220709100739lbb75a6duf34e62de80f71765@mail.gmail.com>
Date: Mon, 10 Sep 2007 15:39:23 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [NFSv4] 2.6.23-rc4 oops in nfs4_cb_recall...
Cc: "Trond Myklebust" <Trond.Myklebust@netapp.com>, nfsv4@linux-nfs.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070909210400.GA7136@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220709040405i4f816afemb3a44d9cd95f9cc@mail.gmail.com>
	 <20070909210400.GA7136@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007, J. Bruce Fields <bfields@fieldses.org> wrote:
> > When accessing a directory inode from a single other client, NFSv4
> > callbacks catastrophically failed [1] on the NFS server with
> > 2.6.23-rc4 (unpatched); clients are both 2.6.22 (Ubuntu Gutsy build).
> > Seems not easy to reproduce, since this kernel was running smoothly
> > for 7 days on the server.
> >
> > What information will help track this down, or is there a known
> > failure mechanism?
>
> I haven't seen that before.
>
> > I can map stack frames to source lines with objdump, if that helps.

> If it's still easy, it might help to figure out exactly where in
> xprt_reserve() it died, and why.  If we've got some race that can lead
> to freeing the client while a callback is in progress, then perhaps this
> is on the first dereference of xprt?

I've raised the bug report into bugzilla, added other observations
from a second occurrence recently and disassembled xprt_reserve with
line numbers.

http://bugzilla.kernel.org/show_bug.cgi?id=9003

Ping me for any more detail/info and thanks!

Daniel
-- 
Daniel J Blueman
