Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbXFDQnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbXFDQnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbXFDQnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:43:10 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:53782 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbXFDQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:43:09 -0400
X-IronPort-AV: i="4.16,381,1175497200"; 
   d="scan'208"; a="490351121:sNHT44752668"
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	<20070601204141.f84ad72f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
	<20070601213117.1178e8e0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
	<84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
	<Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
	<84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
	<alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
	<84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 04 Jun 2007 09:43:00 -0700
In-Reply-To: <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com> (Pekka Enberg's message of "Mon, 4 Jun 2007 19:37:01 +0300")
Message-ID: <ada6463llgr.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jun 2007 16:43:00.0650 (UTC) FILETIME=[69C3F0A0:01C7A6C7]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Then we might as well return your regular NULL pointer for zero-length
 > allocations as you can't do anything sane with ZERO_SIZE_PTR either.

No, because as was mentioned earlier in the thread, we want code to be
able to handle 0-sized allocations without special cases.  The goal is
that code like

	buf = kmalloc(nobj * obj_size);
	if (buf == NULL)
		return -ENOMEM;

should work fine if nobj happens to be 0.  But we do want to get an
oops if the code actually tries to read or write *buf.

 - R.
