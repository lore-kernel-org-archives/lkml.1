Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZCRLPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZCRLPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZCRLPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:15:23 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:50544 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZCRLPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:15:22 -0400
Date: Wed, 18 Mar 2009 12:15:16 +0100 (CET)
From: porte64@free.fr
To: linux-kernel@vger.kernel.org
Message-ID: <1123331339.2730971237374916174.JavaMail.root@spooler8-g27.priv.proxad.net>
Subject: on circular files and an extension to truncate()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [127.0.0.1]
X-Mailer: Zimbra 5.0.15_GA_2815.UBUNTU8_64 (zclient/5.0.15_GA_2815.UBUNTU8_64)
X-Authenticated-User: porte64@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

How about extending the truncate() system call to enable
truncating files from the beginning also ?
This would be useful to help handle history files (logs ...).

One step further -- and i guess many people have already
thought about this:
Circular files could be introduced. I mean files whose
size remains fixed when written to, with the data wrapping
in a circular fashion. This would typically require an
additionnal position parameter ("cursor offset") in userland
stat_t structures.

So circular files would be a sub-category of regular files,
where the write() system call has special handling and updates
the cursor offset.

One advantage of such an implementation is that is would not
depend on the filesystem, and would help in many applications
in which big amounts of data is copied to another file.

I have poor knowledge of the linux kernel so i cannot see
if this suggestion has annoying side-effects and/or
poses compatibility issues.

However, the weaker idea of implementing truncate() with the
possibility to discard data at the beginning of files, then
extending the file, would help a lot.

Phil
