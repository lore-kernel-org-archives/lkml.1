Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYBASQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYBASQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYBASQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:16:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYBASQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:16:06 -0500
Message-ID: <47A3616F.20305@redhat.com>
Date: Fri, 01 Feb 2008 19:14:07 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, "Ed L. Cashin" <ecashin@coraid.com>
Subject: [Patch 0/6] Enhanced partition statistics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is the corrected version of the patchset I posted
here weeks ago and which brings back the I/O statistics concerning
partitions which were lost between 2.4 and 2.6 kernels.

This version still breaks the /sys/block/_disk_/_part_/stat and
/proc/diskstats interfaces. Incidentally iostat is already able to
deal correctly with the new format and both 'iostat -x' and
'iostat -p' already display the enhanced partition statistics.

Adding new information at the end of the line as suggested by Randy,
would also break some user space applications. For example, iostat
which relies on the number of fields to make the difference between
devices and partitions would not work anymore. Moreover it would would
be inconsistent and confusing to display the same statistics in a
different order depending on whether they are related to a device or
a partition.

I do really think that the current interface is confusing and that
user space programs use it improperly. For example, the output of
'iostat -p' is not consistent: the reported tps (tranfers/s) value of
a device and the sum of his partitions are completely dissimillar
because iostat handle in the same manner pre-merge and after-merge
statistics.

'iostat -p' output without Enhanced Partition Statistics:
[root@xxx tmp]# iostat -p
Linux 2.6.24-orig (xxx)      02/01/2008

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.37    0.00    0.25    0.82    0.00   98.56

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
cciss/c0d0        3.12       161.00        18.41     299182      34220
cciss/c0d0p1      1.05         2.10         0.00       3906          4
cciss/c0d0p2      6.67       158.77        18.41     295044      34216
cciss/c0d1        0.16         3.16         0.00       5864          0
cciss/c0d1p1      0.14         0.33         0.00        620          0
cciss/c0d1p2      2.21         2.23         0.00       4148          0
dm-0              6.51       158.56        18.41     294650      34216
dm-1              0.00         0.01         0.00         24          0


'iostat -p' output with Enhanced Partition Statistics:
[root@xxx tmp]# iostat -p
Linux 2.6.24-eps (xxx)       02/01/2008

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.05    0.00    0.09    0.91    0.00   98.95

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
cciss/c0d0        3.15        18.55       136.56     345862    2546140
cciss/c0d0p1      0.01         0.21         0.00       3914          4
cciss/c0d0p2      3.14        18.33       136.56     341724    2546136
cciss/c0d1        0.02         0.31         0.00       5864          0
cciss/c0d1p1      0.01         0.05         0.00       1012          0
cciss/c0d1p2      0.01         0.22         0.00       4148          0
dm-0             17.58        18.31       136.56     341330    2546136
dm-1              0.00         0.00         0.00         24          0

Any comments ?

Regards,
Jerome Marchand

