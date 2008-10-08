Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYJHFQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYJHFQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 01:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYJHFQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 01:16:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59473 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYJHFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 01:16:32 -0400
Date: Tue, 7 Oct 2008 23:16:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Message-ID: <20081008051630.GQ25780@parisc-linux.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 01:48:10PM +0900, Hisashi Hifumi wrote:
> Simultaneous access by two or more writer can corrupt file content,
> so this case needs some locks(flock or fcntl) to preserve synchronization
> of file content. This is responsibility of user-space application.
> But file->f_pos race issue can occur even if multiple threads just read 
> simultaneously. I think this is not responsibility of user-space application. 
> To avoid this currently, an application needs some locks to protect file offset
> even if it just read a file. So I think f_pos race should be fixed.

Why is this application not using pread() / pwrite() to use thread-local
file pointers?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
