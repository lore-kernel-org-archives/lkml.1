Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXKKTji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXKKTji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbXKKTj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:39:28 -0500
Received: from zakalwe.fi ([80.83.5.154]:57130 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbXKKTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:39:28 -0500
Date: Sun, 11 Nov 2007 21:39:26 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Strage buffer behaviour
Message-ID: <20071111193926.GH8865@zakalwe.fi>
References: <20071111183334.GA6770@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071111183334.GA6770@dose.home.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 07:33:35PM +0100, Tino Keitel wrote:
> I noticed that the kernel (2.6.23.1) seems to buffer only certain
> partitions on my system:
> 
> $ for i in 1 2 3 4 ; do for j in 1 2 ; do dd if=/dev/sda$i of=/dev/null
> bs=1024k count=100 ; done ; done
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 3.01471 seconds, 34.8 MB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 2.86945 seconds, 36.5 MB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 2.92038 seconds, 35.9 MB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 3.00272 seconds, 34.9 MB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 4.07722 seconds, 25.7 MB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 0.0944248 seconds, 1.1 GB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 5.61527 seconds, 18.7 MB/s
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 0.331822 seconds, 316 MB/s
> 
> The dd command reads 100 MB from each partition two times in a row. It
> looks like sda1 and sda2 are not bufferd (the first 4 dd runs), but
> sda3 and sda4 are (the last 4 dd runs).

Strange.. I'm running 2.6.24-rc1 here. Reading data from /dev/hda1 
caches well, but not from /dev/sd[ab]1.

PS. you can flush caches with:

	echo 1 > /proc/sys/vm/drop_caches

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
