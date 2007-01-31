Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbXAaANj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbXAaANj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXAaANj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:13:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXAaANi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:13:38 -0500
Message-ID: <45BFDF05.8060008@redhat.com>
Date: Tue, 30 Jan 2007 19:12:53 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bodo Eggert <7eggert@gmx.de>, akpm@osdl.org, dev@sw.ru,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz> <Pine.LNX.4.64.0701301454400.3611@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701301454400.3611@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 30 Jan 2007, Bodo Eggert wrote:
>> change pipefs to use a unique inode number equal to the memory
>> address unless it would be truncated.
> 
> I *really* wouldn't want to expose kernel addresses to user space, it just 
> ends up being a piece of data that they shouldn't have. If we have some 
> security issue, this is just too much kernel information that a bad user 
> could get at.
> 
> 		Linus

Agreed. That was my reasoning for proposing the earlier patch that xor'ed
it with a random value (though that's pretty thin protection too).

I think in hindsight though, just pulling the patch that hashes pipefs
inodes is probably the best thing for now. At some point in the future,
if we decide it's enough of a problem, we can always revisit it.

I'm still planning to look over other callers of new_inode to make a
determination about them wrt to i_ino uniqueness. Many of them are not
as performance sensitive as pipefs, and it might not be such a big deal
to just hash those.

-- Jeff

