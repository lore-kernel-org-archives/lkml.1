Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbYAKAiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbYAKAiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYAKAij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:38:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27738 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYAKAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:38:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a0QKi2mPCxOaqiU4Atfc6QDNolInQgThy1DVOgv7c+UXEERewikTGI/TXJrPVirhTuMScfEOQRHCr7xVh+FJWtiJjd0WoCtnuy+G5cNpfhYWo+o2WRGss+B+Ba3sVtoJLNt1/vCNwaxqVkK+/4GnPY5sd+8rsarnpHFb6ESpjsA=
Subject: [PATCH 0/2][RFC][BUG] msync: another attempt to fix the
	ctime/mtime issue
From: Anton Salikhmetov <salikhmetov@gmail.com>
To: linux-mm@kvack.org
Cc: jakob@unthought.net, linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
       riel@redhat.com, ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com
Content-Type: text/plain
Date: Fri, 11 Jan 2008 03:38:36 +0300
Message-Id: <1200011916.19293.91.camel@codedot>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Salikhmetov <salikhmetov@gmail.com>

I would like to propose my second solution for the bug #2645 from the
kernel bug tracker:

http://bugzilla.kernel.org/show_bug.cgi?id=2645

You may find the relevant background information as well as an extensive
discussion of my previous solution using the following link:

http://lkml.org/lkml/2008/1/9/387

The short change list:

1) taking into account the intervening sync() call which Peter Staubach
has mentioned (http://lkml.org/lkml/2008/1/9/267);
2) splitting the solution into two patches: code cleanup and functional
changes;
3) updating ctime and mtime in do_fsync(), due to that the file time stamps
get updated even without any explicit call to msync().

Please note that the second patch (functional changes) should be applied
on top of the first one (code cleanup).

Also I changed my unit test due to Peter's remark:

http://lkml.org/lkml/2008/1/9/267

The new version of the unit test can be found here:

http://bugzilla.kernel.org/attachment.cgi?id=14398&action=view

No regression was found when I ran the test cases for the msync() system
call from the LTP test suite (msync01 - msync05, mmapstress01,
mmapstress09, and mmapstress10).

