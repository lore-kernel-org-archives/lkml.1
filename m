Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZA0PtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZA0PtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZA0PtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:49:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:40457 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752219AbZA0PtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:49:06 -0500
Date: Tue, 27 Jan 2009 16:49:05 +0100
From: Jan Kara <jack@suse.cz>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: Checkpatch false positive?
Message-ID: <20090127154904.GC8289@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I've used checkpatch.pl to verify one of my patches. It complains:

ERROR: trailing statements should be on next line
#167: FILE: fs/quota/quota_tree.c:249:
+       for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
[...]
             i++, ddquot += info->dqi_entry_size);

  But the code looks like:
        for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
             i < qtree_dqstr_in_blk(info) && !qtree_entry_unused(info, ddquot);
             i++, ddquot += info->dqi_entry_size);

  Which is IMHO correct. Maybe it's because the for has actually empty body
and the ; is at the end of the line with for. But I didn't find anything in
CodingStyle that would forbid
	for (...);
and
	for (...)
		;
Looks a bit strange.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
