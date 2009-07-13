Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZGMIKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZGMIKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZGMIKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:10:21 -0400
Received: from smtp.df.ru ([195.42.160.16]:38591 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZGMIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:10:20 -0400
Date: Mon, 13 Jul 2009 12:11:06 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Counters in df, du
Message-ID: <20090713081106.GA5569@beaver.vrungel.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hi.

Periodically there is an overflow on /tmp on my boxes, and I can't find
the reaason why. May be it isn't a bug in tmpfs and you can help me find
the reason, and if it is an error, I hope you will help me to eliminate
it.

I know that df, du can show different values if some files were deleted,
but the processes which opened these files are still acting.

Well now I see this picture on one of my boxes. Below I post the results
of how I was trying to find what was /tmp full of.

# df -h /tmp
Filesystem            Size  Used Avail Use% Mounted on
tmpfs                 4.1G  3.3G  762M  82% /tmp

# du -hs /tmp
518M    /tmp

# lsof /tmp | awk '{if ($7 != 0) print$0}'
(in attach)

I still don't see any files taking 3G. Now I know only one solution
mount/remount /tmp.

-- 
BRGDS. Alexey Vlasov.

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="tmp.lsof"

# lsof /tmp | awk '{if ($7 != 0) print$0}'
COMMAND     PID                           USER   FD   TYPE             DEVICE  SIZE      NODE NAME
authdaemo  6555                           root    5u  unix 0xffff81030b8c2840       281375180 /var/lib/courier/authdaemon/socket.tmp
authdaemo  6558                           root    5u  unix 0xffff81030b8c2840       281375180 /var/lib/courier/authdaemon/socket.tmp
authdaemo  6559                           root    5u  unix 0xffff81030b8c2840       281375180 /var/lib/courier/authdaemon/socket.tmp
authdaemo  6560                           root    5u  unix 0xffff81030b8c2840       281375180 /var/lib/courier/authdaemon/socket.tmp
authdaemo  6561                           root    5u  unix 0xffff81030b8c2840       281375180 /var/lib/courier/authdaemon/socket.tmp
authdaemo  6562                           root    5u  unix 0xffff81030b8c2840       281375180 /var/lib/courier/authdaemon/socket.tmp
mysqld    22905                          mysql    6u   REG               0,13    20 663938322 /tmp/ib1oZTSZ (deleted)
mysqld    22905                          mysql    8u   REG               0,13 84773 663938424 /tmp/ibRcarbD (deleted)

--xHFwDpU9dbj6ez1V--
