Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYFXNFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYFXNFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbYFXNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:04:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33429 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYFXNEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:04:48 -0400
X-AuditID: 0ac90647-ae526ba000004aeb-3a-4860f0eee4aa
Message-ID: <4860F0BC.1090404@hitachi.com>
Date: Tue, 24 Jun 2008 22:03:56 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a
    write error
References: <485F8822.5030205@hitachi.com> 
    <20080623191733.52c3491c.akpm@linux-foundation.org> 
    <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org> 
    <200806241317.22470.nickpiggin@yahoo.com.au> 
    <alpine.LFD.1.10.0806232039300.2926@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806232039300.2926@woody.linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Thank you for precious comments.

Linus Torvalds wrote:

> 
> On Tue, 24 Jun 2008, Nick Piggin wrote:
> 
>>What you want to do is not insane, but the way it is currently being
>>done is. As I said, just clearing the uptodate bit might blow up your
>>kernel pretty quickly from assertions in the vm. It should be going
>>through the whole truncate or invalidate page machinery in order to
>>do that.
> 
> Fair enough.
> 
> I would not mind, for example, leaving the uptodate bit, but removing it 
> from the radix tree or something like that (ie turning it into an 
> anonymous page for a page-cache page, just removing it from the 
> hash-queues for a buffer_head).

If we move page caches with errors to another radix tree instead of
just removing, we may be able to do special handlings: rewrite once,
or check the page caches and get rid of them from user space, and so on.
 
> Of course, that could cause other problems (eg any VM assertions that 
> shared mappings only contain non-anon pages).

As Jan and Nick stated, this seems to need a great effort, but I think
it is worthwhile to do.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

