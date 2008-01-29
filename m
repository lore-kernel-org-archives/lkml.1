Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYA2L1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYA2L1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYA2L04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:26:56 -0500
Received: from smtp1.kfki.hu ([148.6.0.26]:44115 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbYA2L0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:26:55 -0500
X-Greylist: delayed 2018 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 06:26:55 EST
Date: Tue, 29 Jan 2008 11:53:15 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, Krzysztof Piotr Oledzki <ole@ans.pl>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>
Subject: Re: cups slow on linux-2.6.24
In-Reply-To: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Jeff Chua wrote:

> On Jan 28, 2008 7:18 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > I'm sending printing jobs to a network printer (it's actually printing
> > to the localhost simply creating a file), and running this on
> > Linux-2.6.24 will cause the printing to slow down to 1 print every 3
> > seconds after printing 500 times.
> 
> I bisected the kernel since the last known good 2.6.23 and zeroed in to this
> commit.
> 
> commit 17311393f969090ab060540bd9dbe7dc885a76d5
> Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date:   Thu Oct 11 14:35:52 2007 -0700
> 
>     [NETFILTER]: nf_conntrack_tcp: fix connection reopening
> 
> 
> Reverting this commit solves the problem.
> 
> Version              1000 jobs
> 2.6.23                 90 sec
> 2.6.24              1,492 sec  <== with commit
> 2.6.24(patch)          90 sec  <== reverted the commit
> 
> 
> Since the code has changed an can't simply revert the commit for the latest
> linux git download, I made a patch to revert the above commit. I've tested and
> it's working, but don't know if it breaks other things. Please review.

As the problem can be reproduced so easily, could you capture a full TCP 
session and send the pcap file? Thus it could be analyzed, replayed, etc. 
and found the reason why the patch above slows down the printing.
By reverting back it we loose TCP reopening support.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
