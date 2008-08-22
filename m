Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYHVSIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYHVSIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYHVSIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:08:18 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:50881 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbYHVSIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:08:16 -0400
Subject: Re: NFS regression?  Odd delays and lockups accessing an NFS
	export.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, bfields@fieldses.org, linux-nfs@vger.kernel.org
In-Reply-To: <1219400624.18774.67.camel@zakaz.uk.xensource.com>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	 <1219087258.7192.19.camel@localhost>
	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 11:08:09 -0700
Message-Id: <1219428489.6919.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A9BF52718F1EB503D340AC1E13B928E3CB073EF9
X-UiO-SPAM-Test: remote_host: 198.95.226.240 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 4 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 11:23 +0100, Ian Campbell wrote:
> On Mon, 2008-08-18 at 15:20 -0400, Trond Myklebust wrote:
> > Please try to reproduce the hang, then do
> > 
> > 	echo 0 >/proc/sys/sunrpc/rpc_debug
> > 
> > and send the output from 'dmesg'...
> 
> I've also been seeing some NFS related lockups, although I'm not sure if
> they are the same as the one in this thread or not. Client is 2.6.26
> (Debian's kernel) and Server is 2.6.25 (also a Debian kernel, but from
> backports.org).
> 
> rpc_debug on the server gives nothing, on the client gives:
> [144741.637997] -pid- proc flgs status -client- -prog- --rqstp- -timeout -rpcwait -action- ---ops--
> [144741.637997]  3439 0004 0080    -11 f3f48200 100003 f7770000        0 xprt_sending fa0ae88e fa0bddf4
> [144741.637997]  3438 0001 00a0      0 f77f2a00 100003 f77700d0    15000 xprt_pending fa0ae88e fa0bddf4

That's probably also a networking device driver issue candidate: your
RPC task is queued up waiting to be sent.

What networking card+device driver are you using here?

> There are no processes running with pid 3439 3438 (I don't think it's
> that sort of pid though).

The 'pid' is an internal RPC cookie that just serves to identify and
track specific RPC requests.

Cheers
  Trond

