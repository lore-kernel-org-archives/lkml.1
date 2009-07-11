Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZGKWon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZGKWon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGKWod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:44:33 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:57399 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZGKWoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:44:32 -0400
Subject: Re: How to monitor Linux NFS client load?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200907112103.27082.arvidjaar@mail.ru>
References: <200907112103.27082.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 18:44:27 -0400
Message-Id: <1247352267.7281.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 832 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: CFAEE3B4AF9FDA57BFADFB260E17C9F99290F6A2
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 42 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 21:03 +0400, Andrey Borzenkov wrote:
> Recently we have the case of very high latencies on NFS reads as 
> reported by application (SAP R/3). NFS server was NetApp FAS; according 
> to NetApp statistic, average volume read latencies were in order 10ms, 
> while SAP stats gave 30-50ms. Systems were interconnected by dedicated 
> 1Gb/s Cisco switches (3750G) with ca. 30% max load on interfaces.
> 
> On advice of my colleague we changed sunrpc.tcp_slot_table_entries from 
> default 16 to 128 which seemed to make situation much better - without 
> changing load pattern of filer in any visible way.
> 
> Now, I can understand, why we observed much higher latency on system and 
> why changing (what effectively is) queue depth helped. But I am totally 
> frustrated that there does not appear to be *any* possibility to detect 
> this situation on Linux side and to get a real numbers of real NFS IO 
> latencies or number of requests waiting to be executed (and I do not 
> even dream about per-mount point stats).
> 
> I am grateful for any hints how can we monitor Linux NFS client and get 
> real-life numbers of what happens inside. Thank you!

See the nfs-iostat utility in the nfs-utils package:

http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=blob;f=tools/nfs-iostat/nfs-iostat.py;h=9626d42609b9485c7fda0c9ef69d698f9fa929fd;hb=HEAD

Trond

