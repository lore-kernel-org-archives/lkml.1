Return-Path: <linux-kernel-owner+w=401wt.eu-S2992724AbXEBEt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992724AbXEBEt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992729AbXEBEt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:49:57 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60005 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992724AbXEBEtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:49:55 -0400
Message-Id: <1178081395.2201.1187631545@webmail.messagingengine.com>
X-Sasl-Enc: v9tfHqRvzpYCmXK0I408rZ9kPh6Oy4HJdT9Ub6J6HYk4 1178081395
From: lkml777@123mail.org
To: "Andrew Wang" <andrewxwang@yahoo.com.tw>, linux-kernel@vger.kernel.org
Cc: "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Edward Shishkin" <edward@namesys.com>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
In-Reply-To: <660658.6960.qm@web73512.mail.tp2.yahoo.com>
Date: Tue, 01 May 2007 21:49:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi andrew, it seems that lkml has contacted both of my email accounts
and cripped them.

I can no longer recieve email from lkml on this account.

I can neither recieve or send email to lkml from my other account.

They have also just deleted the 4 emails I sent to lkml from the page
http://lkml.org/lkml/2007/4/30/

This included one to you.

In case you didn't get it,... here it is again.

------------

Yeah, why do you need ZFS while we have ReiserFS4?????

REISER4 - THE BEST FILESYSTEM EVER.

You can read more here:

http://linuxhelp.150m.com/resources/fs-benchmarks.htm
http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

.-------------------------.
| FILESYSTEM | TIME |DISK |
| TYPE       |(secs)|USAGE|
.-------------------------.
|REISER4 lzo | 1938 | 278 |
|REISER4 gzip| 2295 | 213 |
.-------------------------.
|REISER4     | 3462 | 692 |
|EXT2        | 4092 | 816 |
|JFS         | 4225 | 806 |
|EXT4        | 4408 | 816 |
|EXT3        | 4421 | 816 |
|XFS         | 4625 | 779 |
|REISER3     | 6178 | 793 |
|FAT32       |12342 | 988 |
|NTFS-3g     |10414 | 772 |
.-------------------------.


Column one measures the time taken to complete the bonnie++ benchmarking
test (run with the parameters bonnie++ -n128:128k:0). The top two
results use Reiser4 with compression. Since bonnie++ writes test files
which are almost all zeros, compression speeds things up dramatically.
That this is not the case in real world examples can be seen below where
compression does not speed things up. However, more importantly, it does
not slow things down either.

Column two, Disk Usage: measures the amount of disk used to store 655MB
of raw data (which was 3 different copies of the Linux kernel sources).

OR LOOK AT THE FULL RESULTS:

.-------------------------------------------------.
|File         |Disk |Copy |Copy |Tar  |Unzip| Del |
|System       |Usage|655MB|655MB|Gzip |UnTar| 2.5 |
|Type         | (MB)| (1) | (2) |655MB|655MB| Gig |
.-------------------------------------------------.
|REISER4 gzip | 213 | 148 |  68 |  83 |  48 |  70 |
|REISER4 lzo  | 278 | 138 |  56 |  80 |  34 |  84 |
|REISER4 tails| 673 | 148 |  63 |  78 |  33 |  65 |
|REISER4      | 692 | 148 |  55 |  67 |  25 |  56 |
|NTFS3g       | 772 |1333 |1426 | 585 | 767 | 194 |
|NTFS         | 779 | 781 | 173 |   X |   X |   X |
|REISER3      | 793 | 184 |  98 |  85 |  63 |  22 |
|XFS          | 799 | 220 | 173 | 119 |  90 | 106 |
|JFS          | 806 | 228 | 202 |  95 |  97 | 127 |
|EXT4 extents | 806 | 162 |  55 |  69 |  36 |  32 |
|EXT4 default | 816 | 174 |  70 |  74 |  42 |  50 |
|EXT3         | 816 | 182 |  74 |  73 |  43 |  51 |
|EXT2         | 816 | 201 |  82 |  73 |  39 |  67 |
|FAT32        | 988 | 253 | 158 | 118 |  81 |  95 |
.-------------------------------------------------.


Each test was preformed 5 times and the average value recorded.
Disk Usage: The amount of disk used to store the data (which was 3
different copies of the Linux kernel sources).
The raw data (without filesystem meta-data, block alignment wastage,
etc) was 655MB.
Copy 655MB (1): Copy the data over a partition boundary.
Copy 655MB (2): Copy the data within a partition.
Tar Gzip 655MB: Tar and Gzip the data.
Unzip UnTar 655MB: UnGzip and UnTar the data.
Del 2.5 Gig: Delete everything just written (about 2.5 Gig).

http://lkml.org/lkml/2007/4/9/4
-- 
  
  lkml777@123mail.org

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

