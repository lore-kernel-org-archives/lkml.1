Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYHRTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYHRTTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYHRTTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:19:41 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:60028 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYHRTTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:19:39 -0400
Subject: Re: NFS regression?  Odd delays and lockups accessing an NFS
	export.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Athanasius <link@miggy.org>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, neilb@suse.de,
       bfields@fieldses.org, linux-nfs@vger.kernel.org
In-Reply-To: <20080818185048.GO20684@miggy.org>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	 <20080818185048.GO20684@miggy.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 15:19:33 -0400
Message-Id: <1219087173.7192.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 9B0F82F283114020A0CE0DD89F511B3CA2CB51FD
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 19 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 19:50 +0100, Athanasius wrote:
> On Mon, Aug 18, 2008 at 12:02:20PM +1000, Grant Coady wrote:
> > I've been using NFS here for years, lately there's something odd going on 
> > since about a month or so.  Previously reported last month:
> > http://www.gossamer-threads.com/lists/linux/kernel/951419?page=last
> > 
> > Now with 2.6.27-rc3 on one of the client boxes I get a complete stall 
> > at odd times when accessing the server's exported directory, cannot 
> > see a pattern to it.  Eventually recovers after a Ctrl-C.  Nothing in 
> > the server or client log files.  Not easy to reproduce either.
> 
>   I wonder if this is what I've been seeing.  I've been otherwise too
> busy to properly report it, thinking that *someone* else must also be
> seeing it and it's being worked on, else it's a subtle configuration
> problem my end.

Your lockdep trace basically shows that the rpc layer is blocking for
some reason. Could you please try to reproduce the problem, and then do

	echo 0 >/proc/sys/sunrpc/rpc_debug

...and see what the output from 'dmesg' shows?

Cheers
  Trond

