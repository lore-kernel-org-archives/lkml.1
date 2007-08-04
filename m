Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXHDTpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXHDTpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765372AbXHDTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:44:57 -0400
Received: from mail.enyo.de ([212.9.189.167]:2692 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765548AbXHDTo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:44:57 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Aug 2007 15:44:56 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804094119.81d8e533.akpm@linux-foundation.org>
Date: Sat, 04 Aug 2007 21:16:35 +0200
In-Reply-To: <20070804094119.81d8e533.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 4 Aug 2007 09:41:19 -0700")
Message-ID: <87wswbjejw.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton:

> The easy preventive is to mount with data=writeback.  Maybe that should
> have been the default.

The documentation I could find suggests that this may lead to a
security weakness (old data in blocks of a file that was grown just
before the crash leaks to a different user).  XFS overwrites that data
with zeros upon reboot, which tends to irritate users when it happens.

>From this point of view, data=ordered doesn't seem too bad.
