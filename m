Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbZG3WeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbZG3WeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZG3WeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:34:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZG3WeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:34:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=K+wElHqAlKLmRL2W8ZOZxA/xK9Qmh+yVdz+lDWVZdyt3qOD6dSP6VrHyImmVhdNEL
	GNtVdUEx8uCCzlMpaH+5A==
MIME-Version: 1.0
In-Reply-To: <20090730221727.GI12579@kernel.dk>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <20090730213956.GH12579@kernel.dk>
	 <33307c790907301501v4c605ea8oe57762b21d414445@mail.gmail.com>
	 <20090730221727.GI12579@kernel.dk>
Date: Thu, 30 Jul 2009 15:34:12 -0700
Message-ID: <33307c790907301534v64c08f59o66fbdfbd3174ff5f@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The test case above on a 4G machine is only generating 1G of dirty data.
> I ran the same test case on the 16G, resulting in only background
> writeout. The relevant bit here being that the background writeout
> finished quickly, writing at disk speed.
>
> I re-ran the same test, but using 300 100MB files instead. While the
> dd's are running, we are going at ~80MB/sec (this is disk speed, it's an
> x25-m). When the dd's are done, it continues doing 80MB/sec for 10
> seconds or so. Then the remainder (about 2G) is written in bursts at
> disk speeds, but with some time in between.

OK, I think the test case is sensitive to how many files you have - if
we punt them to the back of the list, and yet we still have 299 other
ones, it may well be able to keep the disk spinning despite the bug
I outlined.Try using 30 1GB files?

Though it doesn't seem to happen with just one dd streamer, and
I don't see why the bug doesn't trigger in that case either.

I believe the bugfix is correct independent of any bdi changes?

M.
