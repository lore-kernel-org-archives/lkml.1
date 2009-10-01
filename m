Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZJARMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZJARMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbZJARMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:12:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:38178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbZJARMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:12:52 -0400
Message-ID: <4AC4E2D1.6030804@kernel.org>
Date: Fri, 02 Oct 2009 02:11:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: jeff@garzik.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 15/19] workqueue: reimplement workqueue flushing using
 color coded works
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-16-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010959390.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910010959390.6996@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 17:11:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
> On Thu, 1 Oct 2009, Tejun Heo wrote:
>> Reimplement workqueue flushing using color coded works.  There are two
>> colors and each cwq has the current color which is painted on the
>> works being issued via the cwq.  Flushing a workqueue is achieved by
>> flipping the current colors of each cwq and wait for the works which
>> have the old color to drain.
> 
> Is there any reason for the "two colors" choice? I could imagine that it 
> could end up being a limitation (and possible deadlock?) to allow just a 
> single flush pending at any time.
> 
> Could the color be an 8-bit counter or something like that instead?

It's related to how many bits can be used from work_struct->data which
in turn is determined by the alignment of cwq.  Currently, the
alignment is 8 bytes so 3 bits are available.  One is used for
PENDING, the other for LINKED and one last bit is used for COLOR.
Aligning cwq to, say, 64bytes wouldn't be bad at all and then we can
have 6-bits of coloring.  Hmmm... yeap, I'll work on that.

Thanks.

-- 
tejun
