Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYDESPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYDESPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 14:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYDESPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 14:15:09 -0400
Received: from nn7.de ([85.214.94.156]:46745 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYDESPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 14:15:08 -0400
Subject: Re: 2.6.25-rc8: WARNING: at net/ipv4/tcp_input.c:2173
	tcp_mark_head_lost+0x11d/0x150()
From: Soeren Sonnenburg <kernel@nn7.de>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804052043230.8668@wrl-59.cs.helsinki.fi>
References: <1207199456.7616.3.camel@localhost>
	 <Pine.LNX.4.64.0804031616330.21524@wrl-59.cs.helsinki.fi>
	 <1207230008.4513.14.camel@localhost>
	 <Pine.LNX.4.64.0804031744190.32094@wrl-59.cs.helsinki.fi>
	 <1207413634.4597.4.camel@localhost>
	 <Pine.LNX.4.64.0804052043230.8668@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Sat, 05 Apr 2008 20:14:43 +0200
Message-Id: <1207419283.4597.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-05 at 20:52 +0300, Ilpo Järvinen wrote:
> On Sat, 5 Apr 2008, Soeren Sonnenburg wrote:
> 
> > On Fri, 2008-04-04 at 21:51 +0300, Ilpo Järvinen wrote:
> > > On Thu, 3 Apr 2008, Soeren Sonnenburg wrote:
> > > 
> > > > On Thu, 2008-04-03 at 16:26 +0300, Ilpo Järvinen wrote:
> > > > > On Thu, 3 Apr 2008, Soeren Sonnenburg wrote:
> > > > > 
> > > > > > trying to download things, I am seeing this (ignore the tainted, it is
> > > > > > from madwifi and although the module is loaded the device was never
> > > > > > used)
> > > > > > 
> > > > > > Could anyone make sense of this please?
[...]
> > > 
> > > Here's a debug patch which expensively verifies TCP's state in a number
> > > of places during ACK to find first spot where the actual bug occurs.
> > 
> > OK I am getting this now as the first spot:
> > 
> > P: 4 L: 2 vs 2 S: 0 vs 3 F: 0 vs 0 w: 4023500226-4023505874 (0)
> > skb 0 f495c180
> > skb 1 f480a180
> > skb 2 f4994600
> > head 3 f495c780
> > skb 4 f5b32480
> > TCP wq(s) LL  <
> > WARNING: at net/ipv4/tcp_ipv4.c:240 tcp_verify_wq+0x319/0x3c0()
> >
> > another one:
> > WARNING: at net/ipv4/tcp_output.c:1475 __tcp_push_pending_frames+0x70/0x830()
> > 
> > 
> > P: 4 L: 2 vs 2 S: 0 vs 3 F: 0 vs 0 w: 4023500226-4023505874 (0)
> > skb 0 f495c180
> > skb 1 f480a180
> > skb 2 f4994600
> > head 3 f495c780
> > skb 4 f5b32480
> > TCP wq(s) LL  <
> > TCP wq(h) +-++<
> > l2 s3 f0 p4 seq: su4023500226 hs241530103 sn4023505874
> > ------------[ cut here ]------------
> > WARNING: at net/ipv4/tcp_ipv4.c:240 tcp_verify_wq+0x319/0x3c0()
> 
> Please don't cut the log! It is caught here because 2+3 > 4 :-) but I need 
> the full log with stacktraces this time to figure it out.

Look here 
http://nn7.de/debugging/tcp.log :-)

HTH,
Soeren

