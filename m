Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZDNU6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZDNU6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZDNU6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:58:43 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:43321 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZDNU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:58:43 -0400
Subject: [PATCH 0/2] ext3 data=guarded
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 16:57:13 -0400
Message-Id: <1239742633.28321.39.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49E4F8B5.00B3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Here is the ext3 data=guarded code again, this time it has passed some
basic tests.  It should safely leave non data=guarded mounts alone and
only be dangerous when the new code is turned on (I hope).

On the performance side, it runs the same as data=writeback, except when
you're making files with holes where it runs the same as data=ordered.

There's definitely more CPU time involved with tracking the data=guarded
buffer heads and updating i_size when the IO is over, but at least on my
5 drive array that doesn't show up.

For the fsync + background streaming write workload, data=guarded does
fsync's in 0.8s, just like data=writeback.  data=ordered on the same
test was doing between 5 and 30s per fsync, so it seems I've fixed that
part at least.

The next step is much more testing (blocksize != pagesize among others)
and much more review.  But, I'm hoping for some feedback first on if
this is a direction we want to take the ext3 code.

The diffstat looks scary, but lots of the changes are comments...

-chris


