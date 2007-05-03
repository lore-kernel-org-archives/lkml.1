Return-Path: <linux-kernel-owner+w=401wt.eu-S1161162AbXECVKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162AbXECVKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031352AbXECVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:10:30 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4176 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031350AbXECVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:10:29 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: scheduling oddity on 2.6.20.3 stock
Date: Thu, 3 May 2007 14:10:23 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEJKDIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <Pine.LNX.4.64.0705021826560.5342@asgard.lang.hm>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 03 May 2007 15:10:45 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 03 May 2007 15:10:47 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I needed to recompress some files from .bz2 to .gz so I setup a script to
> do
>
> bunzip2 -c $file.bz2 |gzip -9 >$file.gz
>
> I expected that the two CPU heavy processes would end up on different
> cpu's and spend a little time shuffling data between the two cpu's on a
> system (dual core opteron)
>
> however, instead what I find is that each process is getting 50% of one
> cpu while the other cpu is 97% idle.

That would only be possible if the compression/decompression block size is
small compared to the maximum pipe buffer size. I suspect the reverse is the
case.

It would be interesting to write an intermediate process that basically
enlarged the pipe buffers and see if that changed anything. Basically, the
intermediate process would allocate a large buffer (16MB or so) and fill it
from 'bunzip2' while draining it to 'gzip' in a non-blocking way (unless the
buffer was full/empty, of course).

DS


