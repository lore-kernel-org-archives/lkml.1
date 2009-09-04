Return-Path: <linux-kernel-owner+w=401wt.eu-S934275AbZIDUzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbZIDUzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934025AbZIDUzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:55:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39558 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855AbZIDUzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:55:19 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/4] Safely removing mmaped files
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 Sep 2009 12:24:44 -0700
Message-ID: <m1fxb2wm0z.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, tj@kernel.org, gregkh@suse.de, adobriyan@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently when mmaped files are removed I have not found a single
instance in the kernel where we handle it correctly.  Frequently after
a hot remove we will either leak a file (with weird ensuing
consequences) or we will goof and not call vm_ops->close() which can
cause leaks.

It turns out this problem isn't too bad to actually fix and this
patchset is my generic solution.  Tested against 2.6.31-rc8 with a
process that mmaped /sys/*/*/resource0 and /proc/bus/pci/*/*.

I'm not certain what the best way to carry these patches is to get
them merged.  Andrew can you carry this patchset?


Eric
