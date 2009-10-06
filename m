Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZJFKWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZJFKWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZJFKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZJFKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:22:08 -0400
Date: Tue, 6 Oct 2009 12:21:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091006102136.GH9832@redhat.com>
References: <20091006095111.GG9832@redhat.com>
 <20091006190938.126F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006190938.126F.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 07:11:06PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > If application does mlockall(MCL_FUTURE) it is no longer possible to
> > mmap file bigger than main memory or allocate big area of anonymous
> > memory. Sometimes it is desirable to lock everything related to program
> > execution into memory, but still be able to mmap big file or allocate
> > huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
> > allows to do that.
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> 
> Why don't you use explicit munlock()?
Because mmap will fail before I'll have a chance to run munlock on it.
Actually when I run my process inside memory limited container host dies
(I suppose trashing, but haven't checked).

> Plus, Can you please elabrate which workload nedd this feature?
> 
I wanted to run kvm with qemu process locked in memory, but guest memory
unlocked. And guest memory is bigger then host memory in the case I am
testing. I found out that it is impossible currently.

--
			Gleb.
