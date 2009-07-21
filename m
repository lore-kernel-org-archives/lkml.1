Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZGUR6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZGUR6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZGUR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:58:30 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:60096 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZGUR63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:58:29 -0400
Subject: Re: [2.6.30.1] Significant latency playing video file from NFS4
 share
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <200907211931.50015.elendil@planet.nl>
References: <200907172250.51504.elendil@planet.nl>
	 <1247871086.4945.38.camel@heimdal.trondhjem.org>
	 <200907180131.12586.elendil@planet.nl>
	 <200907211931.50015.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 13:58:25 -0400
Message-Id: <1248199105.21343.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 2 sum rcpts/h 8 sum msgs/h 2 total rcpts 906 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 4D1E5F47E286FD86400BC392E3BC1DCAD8BA994A
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 75 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 19:31 +0200, Frans Pop wrote:
> Any suggestions based on the data below?

Yeah. Sorry for the delay.

> Is the problem maybe that the amount of data transferred each time is so
> big that the network speed becomes a bottleneck and causes the latency?
> I can reproduce the issue with both a 10MBit wired link and with a 54MBit
> wireless link.
> 
> Is this a kernel bug or a configuration issue?

<snip>

> elrond:/david mounted on /srv/fjp/david:
> 
>    op/s         rpc bklog
>    0.80            0.00
> read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)
>                   0.750         192.196         256.262        0 (0.0%)         1998.933        1999.200
> write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)
>                   0.000           0.000           0.000        0 (0.0%)           0.000           0.000

This would be where you are losing your performance. 1998.933 ms rtt
means that you are seeing a 2 second delay from the instant the RPC
client pushes the request into the socket to the moment that socket
receives a reply from the server.

Basically, you have either a _very_ slow server, or (more likely) a
networking problem. A tcpdump ought to be able to show what the problem
is: whether it is the packets getting ACKed very slowly, and/or if you
have dropped packet issues or if it is truly a problem with the server
taking a long time to reply.

Cheers
  Trond

