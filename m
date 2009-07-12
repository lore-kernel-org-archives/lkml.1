Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZGLQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZGLQbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 12:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGLQbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 12:31:04 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50365 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZGLQbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 12:31:02 -0400
Subject: Re: How to monitor Linux NFS client load?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200907120838.06766.arvidjaar@mail.ru>
References: <200907112103.27082.arvidjaar@mail.ru>
	 <1247352267.7281.2.camel@heimdal.trondhjem.org>
	 <200907120838.06766.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Sun, 12 Jul 2009 12:30:57 -0400
Message-Id: <1247416257.13973.0.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 838 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-3.2, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5,URI_HEX=1.777, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: 57C1C9CAEE92E55B692D15A29923BBF68B94A90C
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -31 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 44 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-12 at 08:38 +0400, Andrey Borzenkov wrote:
> On Sunday 12 of July 2009 02:44:27 Trond Myklebust wrote:
> > On Sat, 2009-07-11 at 21:03 +0400, Andrey Borzenkov wrote:
> > > Recently we have the case of very high latencies on NFS reads as
> > > reported by application (SAP R/3). NFS server was NetApp FAS;
> > > according to NetApp statistic, average volume read latencies were
> > > in order 10ms, while SAP stats gave 30-50ms. Systems were
> > > interconnected by dedicated 1Gb/s Cisco switches (3750G) with ca.
> > > 30% max load on interfaces.
> > >
> > > On advice of my colleague we changed sunrpc.tcp_slot_table_entries
> > > from default 16 to 128 which seemed to make situation much better -
> > > without changing load pattern of filer in any visible way.
> > >
> > > Now, I can understand, why we observed much higher latency on
> > > system and why changing (what effectively is) queue depth helped.
> > > But I am totally frustrated that there does not appear to be *any*
> > > possibility to detect this situation on Linux side and to get a
> > > real numbers of real NFS IO latencies or number of requests waiting
> > > to be executed (and I do not even dream about per-mount point
> > > stats).
> > >
> > > I am grateful for any hints how can we monitor Linux NFS client and
> > > get real-life numbers of what happens inside. Thank you!
> >
> > See the nfs-iostat utility in the nfs-utils package:
> >
> > http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=blob;f=tools/nfs-i
> >ostat/nfs-iostat.py;h=9626d42609b9485c7fda0c9ef69d698f9fa929fd;hb=HEAD
> >
> 
> This looks exactly like what is required, except ...
> 
> cn1:~ # ./nfs-iostat.py 2
> Traceback (most recent call last):
>   File "./nfs-iostat.py", line 559, in ?
>     iostat_command(prog)
>   File "./nfs-iostat.py", line 464, in iostat_command
>     mountstats = parse_stats_file('/proc/self/mountstats')
>   File "./nfs-iostat.py", line 434, in parse_stats_file
>     f = file(filename)
> IOError: [Errno 2] No such file or directory: '/proc/self/mountstats'
> 
> Which minimum kernel version is required for it?
> 
> Thank you!

You need kernel 2.6.17 or newer.

Cheers
  Trond

