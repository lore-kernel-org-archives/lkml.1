Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYICXB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYICXB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYICXBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:01:13 -0400
Received: from smtp.ono.com ([62.42.230.12]:51665 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753543AbYICXBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:01:11 -0400
Date: Thu, 4 Sep 2008 01:00:43 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Finding what is stuck...
Message-ID: <20080904010043.408b3f03@one.home>
In-Reply-To: <20080901170812.2c3b041b@infradead.org>
References: <20080902020447.5b48b083@one.home>
 <20080901170812.2c3b041b@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 17:08:12 -0700, Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 2 Sep 2008 02:04:47 +0200
> "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
> > Hi all...
> > 
> > I'm running 2.6.27-rc5-git2 on an Aspire One.
> > The system is in general pretty responsive, but sometimes it just gets
> > totally stuck. Even the mouse stops. 
> > 
> > It looks related to disk (SSD) access, but I'm not totally sure.
> > Is there any way to find what is getting stuck ? I know that SSDs can
> > be slow on write, I don't mind if the system is faster or slower
> > (it's small :))), but if the speed is constant. That occasional
> > pauses are strange, like if SSD flushing gets stuck on BKL
> > (I know, no idea about what I talk...).
> > 
> > I'm using ext3 fs, noop iosched. But as I say, I'm not sure that the
> > disk writes are the culprit.
> > 
> > Any idea about how to find this ?
> 
> Have you tried to run "latencytop"?
> (you need to enable this in the kernel config as well)
> 
> it tends to (for me at least) point out very well where stalls happen,
> or at least, what the system is doing when they happen.
> 
> (hint: make sure you do "make install" before running it)
> 

These are some shots of latencytop while working. I copied the screen
when I saw any very high timing...

Cause                                                Maximum     Percentage
Walking directory tree                            790.2 msec         10.6 %
Scheduler: waiting for cpu                         40.5 msec         38.5 %

fsync() on a file                                 3191.6 msec         36.7 %
Reading EXT3 directory                            1553.3 msec          3.9 %
EXT3: Waiting for journal access                  1518.7 msec          3.8 %
Deleting an inode                                 657.5 msec          1.7 %
EXT3: Looking for file                            576.3 msec          1.4 %
Writing a page to disk                            363.0 msec          6.1 %
call_usermodehelper_exec request_module __sock_cre 69.4 msec          0.2 %
Scheduler: waiting for cpull                       28.0 msec         18.9 %
Page fault                                          7.9 msec          0.3 %

fsync() on a file                                 8843.7 msec         81.8 %
Writing a page to disk                            1548.6 msec          2.9 %
EXT3: Waiting for journal access                  356.5 msec          1.1 %
Scheduler: waiting for cpu                         40.6 msec          6.0 %

EXT3: Waiting for journal access                  6153.6 msec         17.2 %
fsync() on a file                                 4902.7 msec         53.5 %
Writing a page to disk                            3487.2 msec          9.8 %
Writing buffer to disk (synchronous)              2288.7 msec          4.6 %
synchronous write                                 1320.6 msec          2.6 %
Truncating file                                   302.6 msec          0.6 %
Page fault                                        290.5 msec          0.6 %
Scheduler: waiting for cpu                         13.4 msec          4.5 %
Waiting for event (select)                          5.0 msec          5.0 %

Deleting an inode                                 5584.7 msec         27.5 %
Writing a page to disk                            829.2 msec          5.4 %
fsync() on a file                                 265.1 msec         11.2 %
Scheduler: waiting for cpu                         37.2 msec         11.5 %
stat() operation                                    5.6 msec          0.1 %
Page fault                                          5.5 msec          0.2 %
Waiting for event (select)                          5.0 msec         39.8 %
Waiting for event (poll)                            5.0 msec          2.5 %
synchronous write                                   4.2 msec          0.0 %

All look fs access:

one:~# df
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda1     ext3    6.9G  3.7G  3.2G  55% /
tmpfs        tmpfs    246M   12K  246M   1% /tmp
/dev/mmcblk0p1
              ext3    1.9G   35M  1.8G   2% /store

I will try mounting root as ext2, to rule out jorunaling...

TIA

-- 
J.A. Magallon                       \                     Software is like sex:
                                     \               It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux kernel 2.6.23-jam01,  gcc version 4.2.2 20070909
