Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbXIUKAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbXIUKAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXIUKAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:00:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:48671 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXIUKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=O5PzrqCtmDl6U0UFNqsANH8gVoaFzs/bgn7U6QXESED9SUrDLp/MI+V/g6XeJ9dpFpUVm1atJkLqwiAR7GHCoyIMNg99r8JEMvC3/vTTjVGO6Kep1YIhtmWiO4N9xZyLshkml2oGecrLOHJMdehsvZNElnW5UOkKRLJQnnOHOAg=
Date: Fri, 21 Sep 2007 12:00:41 +0200
From: =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] Possible cache memory leak.
Message-ID: <20070921100041.GB19050@kazikbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've discovered a strange thing lately. My memory is being sucked out
when doing (I suppose) _a lot_ of stat() on the file system. I got left
once with ~30MB of ram (of 512 in total) which made my system trash
like hell. You might try doing the following to reproduce the effect:

 $ echo 1 > /proc/sys/vm/drop_caches
 $ vmstat                            # write down the result
 $ du -s -x /lots/of/files           # keep it running for a minute
 $ echo 1 > /proc/sys/vm/drop_caches
 $ vmstat                            # write it down too

The latter vmstat should report less memory then the previous one.
(sum up free+buff+cache) Is this an expected behaviour ? If yes,
please explain.

The memory can be magically freed by umount-ing the partition that was
scanned or by deleting the files that were stat()-ed. However, one
cannot simply umount "/".

Note: Make sure you point 'du' to a place where you have dozens of
files, so it can keep it running for a minute or more.

I can confirm that to be an issue to 2.6.23-rc6 and 2.6.23-rc7.
A friend of mine reports that 2.6.22.5 produces same results.
Tested on jfs and ext3.


Regards,
Michał Kazior.


PS. I'm not subscribed to the list, so CC me please.

