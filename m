Return-Path: <linux-kernel-owner+w=401wt.eu-S1030433AbXD1CuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433AbXD1CuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030456AbXD1CuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:50:22 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:29389 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030433AbXD1CuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:50:21 -0400
X-IronPort-AV: i="4.14,463,1170662400"; 
   d="scan'208"; a="56867583:sNHT42900408"
To: akpm@linux-foundation.org, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: commit 45cd8d8e -- why?
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 27 Apr 2007 19:50:19 -0700
Message-ID: <ada647hnrf8.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 02:50:19.0290 (UTC) FILETIME=[F530A7A0:01C7893F]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The changelog says:

    fs/sysfs/bin.c: In function 'read':
    fs/sysfs/bin.c:77: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'int'

but the signature of the function read() is

    read(struct file * file, char __user * userbuf, size_t count, loff_t * off)

and git blame seems to show it was always thus -- ie count was always size_t.

And now on x86-64 and ia64 with gcc 4.1 at least, I get:

    fs/sysfs/bin.c: In function 'read':
    fs/sysfs/bin.c:62: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Andrew, what compiler were you using to get that warning?  Should we
revert commit 45cd8d8e?

 - R.
