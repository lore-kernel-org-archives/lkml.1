Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXBDAVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXBDAVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXBDAVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:21:34 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:1334 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXBDAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:21:33 -0500
X-IronPort-AV: i="4.13,277,1167638400"; 
   d="scan'208"; a="385480744:sNHT44995420"
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: A CodingStyle suggestion
X-Message-Flag: Warning: May contain useful information
References: <20070203215848.GA10440@Ahmed> <45C51310.6070304@student.ltu.se>
	<20070204000532.GA20721@Ahmed>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 03 Feb 2007 16:21:18 -0800
In-Reply-To: <20070204000532.GA20721@Ahmed> (Ahmed S. Darwish's message of "Sun, 4 Feb 2007 02:05:32 +0200")
Message-ID: <aday7neydq9.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2007 00:21:21.0375 (UTC) FILETIME=[657DCEF0:01C747F2]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Good catch :). A small grep of `access_ok' reveals that it's always used in the 
 > form of:
 > if (!access_ok()) { .. }
 > 
 > I can conclude that verbal/imperative methods like `kmalloc, add_work' be 
 > checked as:
 > ret = do_work();
 > if (ret) { ... }
 > and predicate methods like `acess_ok, pci_dev_present' be checked like:
 > if (!access_ok) { ... }
 > if (pci_dev_present) { ...}
 > 
 > Any comments ?

I don't think that's really the distinction that matters.  I think
really the issue is that assignment within an if is hard to read, so

	ret = foo(a, b);
        if (ret) { ... }

is clearly preferred to

	if ((ret = foo(a,b))) { ... }

However, in my opinion something like

	if (foo(a,b)) { ... }

if perfectly fine if the return value of foo is not needed anywhere
else.  In other words, there's no sense introducing a temporary
variable to hold the return value if you're never going to do anything
with it other than check it on the next line.

 - R.
