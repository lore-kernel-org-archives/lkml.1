Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXKKKHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXKKKHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 05:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXKKKG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 05:06:56 -0500
Received: from hpsmtp-eml13.KPNXCHANGE.COM ([213.75.38.113]:37510 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXKKKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 05:06:56 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Bind mount bug?
Date: Sun, 11 Nov 2007 11:06:52 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711111106.53494.elendil@planet.nl>
X-OriginalArrivalTime: 11 Nov 2007 10:06:54.0175 (UTC) FILETIME=[95EFA6F0:01C8244A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure whether this is a bug or expected behavior.
Suppose I create a "looped" bind mount situation as follows.

# mkdir test
# touch test/foo
# mkdir bindtest
# touch bindtest/bar
# mkdir bindtest/test
# mount --bind test/ bindtest/test/
# ls bindtest/test/
foo
# mount --bind bindtest/ test/
# ls test/
bar  test
# ls test/test/
#

I'd expected the last command to list "foo", but it shows an empty dir.
Shouldn't it also show the original contents of test (as they were before 
the first bind mount)?

# mount | grep test
/root/test on /root/bindtest/test type none (rw,bind)
/root/bindtest on /root/test type none (rw,bind)

Cheers,
Frans Pop
