Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZFRFdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZFRFdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZFRFdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:33:03 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:35519 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZFRFdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:33:02 -0400
From: hooanon05@yahoo.co.jp
To: zohar@us.ibm.com
cc: linux-kernel@vger.kernel.org
Subject: IMA and ETXTBSY
Date: Thu, 18 Jun 2009 14:32:58 +0900
Message-ID: <8916.1245303178@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After the failure of open(2) with ETXTBSY, IMA produces wrong messages.
Here is a simple test script.

dir=/tmp
cp /bin/sleep $dir
ls -l $dir/sleep
stat -f $dir
$dir/sleep 3 & sleep 1
echo | /bin/dd of=$dir/sleep conv=notrunc && false
wait
rm $dir/sleep


The result.
+ cp /bin/sleep /tmp
+ ls -l /tmp/sleep
-rwxr-xr-x 1 jro jro 23504 Jun 18 14:26 /tmp/sleep
+ stat -f /tmp
  File: "/tmp"
    ID: 4e22c34ea8177d80 Namelen: 255     Type: ext2/ext3
Block size: 1024       Fundamental block size: 1024
Blocks: Total: 918322     Free: 918281     Available: 869285
Inodes: Total: 490560     Free: 490545
+ /tmp/sleep 3
+ sleep 1
+ echo
+ /bin/dd of=/tmp/sleep conv=notrunc
/bin/dd: opening `/tmp/sleep': Text file busy
+ wait
+ rm /tmp/sleep
$ iint_free: writecount: 1
iint_free: opencount: 1


J. R. Okajima
