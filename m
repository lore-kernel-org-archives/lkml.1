Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYFXDmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYFXDmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYFXDm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:42:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYFXDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:42:24 -0400
Date: Mon, 23 Jun 2008 20:42:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a
 write error
In-Reply-To: <200806241317.22470.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0806232039300.2926@woody.linux-foundation.org>
References: <485F8822.5030205@hitachi.com> <20080623191733.52c3491c.akpm@linux-foundation.org> <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org> <200806241317.22470.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Nick Piggin wrote:
> 
> What you want to do is not insane, but the way it is currently being
> done is. As I said, just clearing the uptodate bit might blow up your
> kernel pretty quickly from assertions in the vm. It should be going
> through the whole truncate or invalidate page machinery in order to
> do that.

Fair enough.

I would not mind, for example, leaving the uptodate bit, but removing it 
from the radix tree or something like that (ie turning it into an 
anonymous page for a page-cache page, just removing it from the 
hash-queues for a buffer_head).

Of course, that could cause other problems (eg any VM assertions that 
shared mappings only contain non-anon pages).

		Linus
