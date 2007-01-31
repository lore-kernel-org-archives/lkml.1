Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXAaUlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXAaUlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030484AbXAaUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:41:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:31807 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030456AbXAaUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:41:54 -0500
In-Reply-To: <20070131200502.GO1344@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <6CDD5D9D-E031-499D-9A8A-5A8522C66D37@oracle.com> <20070131175118.GN1344@kvack.org> <FA6A1934-9D3D-456E-BDF6-3530D74BB657@oracle.com> <20070131200502.GO1344@kvack.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D9B3FCED-B132-4833-9CBF-39B06E551132@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 12:41:11 -0800
To: Benjamin LaHaise <bcrl@kvack.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Take FPU state: memory copies and RAID xor functions use MMX/SSE and
> require that the full task state be saved and restored.

Sure, that much is obvious.  I was hoping to see what FPU state  
juggling actually requires.  I'm operating under the assumption that  
it won't be *terrible*.

> Task priority is another.  POSIX AIO lets you specify request  
> priority, and
> it really is needed for realtime workloads where things like keepalive
> must be processed at a higher priority.

Yeah.  A first-pass approximation might be to have threads with asys  
system calls grouped by priority.  Leaving all that priority handling  
to the *task* scheduler, instead of the dirt-stupid fibril  
"scheduler", would be great.  If we can get away with it.  I don't  
have a good feeling for what portion of the world actually cares  
about this, or to what degree.

- z
