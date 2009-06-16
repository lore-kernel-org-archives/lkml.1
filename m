Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbZFPQI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbZFPQI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZFPQIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:08:19 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:4938 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbZFPQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:08:19 -0400
X-Greylist: delayed 1458 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 12:08:19 EDT
Date: Tue, 16 Jun 2009 17:43:42 +0200
From: Ralf Gross <rg@stz-softwaretechnik.com>
To: linux-kernel@vger.kernel.org
Subject: io-scheduler tuning for better read/write ratio
Message-ID: <20090616154342.GA7043@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to tune the kernel/io-scheduler for better read/write
ratio on a Areca RAID0 device (4 disks, kernel 2.6.26, xfs fs).

I can get 200 MB/s seq. writes and about the same for seq. reads. My
problem is that if there are reads _and_ writes on this device, the
write throughput is much higher than the read throughput (40 MB/s
read, 90 MB/s write).

The deadline scheduler sounded like the way to go for getting better
read results, but reagardless which parameter I change, the ratio keeps
the same.

cfq, noop.. different paramter settings, but alway the same result.

short: is there a way to tune the kernel/scheduler settings in a way
to get a higher read throughput? Writes are not that important,
basicially there are only two 30 GB files on the device/filesystem
that are used to spool data for two LTO-4 tape drives. So I need a
certain read speed to keep both drives streaming. While the data gets
written to one file, I need at least 50 MB/s for reading from the
other file and sent to the tape drive.

Thanks, Ralf
