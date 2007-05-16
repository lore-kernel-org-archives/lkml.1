Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbXEPUH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbXEPUH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762483AbXEPUG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:06:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2403 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762372AbXEPUGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:06:55 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <david@lang.hm>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: scheduling oddity on 2.6.20.3 stock
Date: Wed, 16 May 2007 13:06:28 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEIIDNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0705161247490.1280@asgard.lang.hm>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 16 May 2007 14:06:55 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 16 May 2007 14:06:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 3 May 2007, David Schwartz wrote:
>
> >> I needed to recompress some files from .bz2 to .gz so I setup
> a script to
> >> do
> >>
> >> bunzip2 -c $file.bz2 |gzip -9 >$file.gz
> >>
> >> I expected that the two CPU heavy processes would end up on different
> >> cpu's and spend a little time shuffling data between the two cpu's on a
> >> system (dual core opteron)
> >>
> >> however, instead what I find is that each process is getting 50% of one
> >> cpu while the other cpu is 97% idle.
> >
> > That would only be possible if the compression/decompression
> block size is
> > small compared to the maximum pipe buffer size. I suspect the
> reverse is the
> > case.
>
> I'm still running into this problem in various forms
>
> is there an easy way to change the maximum pipe buffer size? (including a
> simple change to the kernel source, I do compile my own kernels)

No. Changing the size will not do what you want it to do since that only
tells the kernel what the size is, it does not determine what it is.

> > It would be interesting to write an intermediate process that basically
> > enlarged the pipe buffers and see if that changed anything.
> > Basically, the
> > intermediate process would allocate a large buffer (16MB or so)
> > and fill it
> > from 'bunzip2' while draining it to 'gzip' in a non-blocking
> > way (unless the
> > buffer was full/empty, of course).

It is not particularly hard to write such a process. I have a proxy that I
can easily tweak to do this. I'm going to give it a shot and see if it
helps.

DS


