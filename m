Return-Path: <linux-kernel-owner+w=401wt.eu-S966038AbXDHAo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966038AbXDHAo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 20:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966037AbXDHAo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 20:44:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51436 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966032AbXDHAo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 20:44:57 -0400
Message-Id: <1175993097.32498.1183512070@webmail.messagingengine.com>
X-Sasl-Enc: B6ewHkXQsRr5Lxb7q1sZLP+1cVbac3XGnZuvzF71bGVM 1175993097
From: johnrobertbanks@fastmail.fm
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ignatich" <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <461592FB.5060507@zytor.com>
   <1175819681.20754.1183287946@webmail.messagingengine.com>
   <461596DE.2020802@zytor.com>
   <1175823288.25662.1183293506@webmail.messagingengine.com>
   <4615C780.5040407@zytor.com>
   <1175833931.8916.1183307802@webmail.messagingengine.com>
   <20070407191715.GG3510@csclub.uwaterloo.ca>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <20070407191715.GG3510@csclub.uwaterloo.ca>
Date: Sat, 07 Apr 2007 17:44:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart. Tell me again that these results from 

http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm

are not of interest to you. I still don't understand why you have your
head in the sand.

.-------------------------.
| FILESYSTEM | TIME |DISK |
| TYPE       |(secs)|USAGE|
.-------------------------.
|REISER4 lzo | 1938 | 278 |
|REISER4 gzip| 2295 | 213 |
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
test (run with the parameters bonnie++ -n128:128k:0)

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

To get a feel for the performance increases that can be achieved by
using compression, we look at the total time (in seconds) to run the
test:

bonnie++ -n128:128k:0 (bonnie++ is Version 1.93c)

.-------------------.
| FILESYSTEM | TIME |
.-------------------.
|REISER4 lzo |  1938|
|REISER4 gzip|  2295|
|REISER4     |  3462|
|EXT4        |  4408|
|EXT2        |  4092|
|JFS         |  4225|
|EXT3        |  4421|
|XFS         |  4625|
|REISER3     |  6178|
|FAT32       | 12342|
|NTFS-3g     |>10414|
.-------------------.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Access all of your messages and folders
                          wherever you are

