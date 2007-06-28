Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbXF1QTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbXF1QTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXF1QTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:19:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:12011 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbXF1QTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FMMPqYiw1nhQ1C2k6rVmuKkrHwYDhILHxxfatdEr2pcoPFrYI5coyCt5WLbY4LJTA9aY1Nrqkzs0+mDdv5Kqzv3ont03e5NaqQlG7e+f/OKoieh6oUq/ISfO/tV/BMDmGOQfB/S9W8EPvpXKoeb3XZ6cA9kg++c/AerGxDTBlIA=
Message-ID: <a781481a0706280919i2a649873x3f56ae9d5e9c4c9f@mail.gmail.com>
Date: Thu, 28 Jun 2007 21:49:42 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	 <E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
	 <20070609070826.7bd3480c.jlayton@redhat.com>
	 <a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	 <20070626115449.GA92@tv-sign.ru>
	 <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
	 <20070627122437.GA158@tv-sign.ru>
	 <a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
	 <20070628141246.GA95@tv-sign.ru>
	 <a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 6/28/07, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > [...]
> > Hmm... actually, such a change breaks the
> >
> >         while (signal_pending(current))
> >                 dequeue_signal_and_so_something();
> >
> > loop, see jffs2_garbage_collect_thread() for example.

BTW jffs2_garbage_collect_thread() is a horrible abomination :-)
Its use of SIGSTOP and SIGHUP is *totally* gratuitous & unwarranted.
It does use SIGKILL, but simply as a stop-notification from umount
of the corresponding jffs2 partition.

I think all the signal handling there can be removed; then it needs
to undergo conversion to kthread (it uses horrible locks and
completions to handle its exit) -- I'll put it in my endless
kernel-cleanups-todo-list ...
