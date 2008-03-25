Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbYCYVp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbYCYVp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761000AbYCYVjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:39:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:48981 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760979AbYCYVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M0c87bI02TQ6pBVRU/XnEOW4Jb9w1F4xySlJBObuWhVZhLQy8idJ+Qi4Gb2nCyIGXYldeR/nzqxjIQI+aTJ8/i59kN8N2XsNlWaQDvxWvmBCmMQUr/Wqt9tIeR5N8SiJjVJ6d2AHbKP49Moi4DEb9pPCjAsvFKzAp5a+xc0q5O0=
Message-ID: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
Date: Tue, 25 Mar 2008 22:39:39 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Why /proc/cpuinfo doesn't print L1,L2,L3 caches?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 47
model name      : AMD Athlon(tm) 64 Processor 3200+
...
cache size      : 512 KB
...

The cache size is currently misinformed. It's not the real size because
it's 64+64+512 KiB = 640 KiB, not 512 KB.

How can i know what hw-caches use the processors?
The current kernel doesn't know well what hw-caches uses.

The good proposal is by example (the data below are not real):
* In old AMD Athlon64:

cache L1        : 64 KiB I + 64 KiB D, 64 B line, direct way, ...
cache L2        : 512 KiB I+D-shared, exclusive, 128 associative way, ...
cache L3        : none

* In Intel Core Duo:
processor       : 0
cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
cache L2        : 2048 KiB Cores-shared, inclusive, 128 associative way, ...
cache L3        : none

processor       : 1
cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
cache L2        : 2048 KiB cores-shared, inclusive, 128 associative way, ...
cache L3        : none

* In Quad:
processor       : 0
cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
associative way, ...
cache L3        : none
...
processor       : 3
cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
associative way, ...
cache L3        : none

It above is an example, put your symbols to /proc/cpuinfo in a
convenient manner.

   Good bye ;)
