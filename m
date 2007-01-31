Return-Path: <linux-kernel-owner+w=401wt.eu-S1030239AbXAaSAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030239AbXAaSAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030240AbXAaSAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:00:16 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56538 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239AbXAaSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:00:14 -0500
In-Reply-To: <Pine.LNX.4.64.0701301853190.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org> <Pine.LNX.4.64.0701301853190.3611@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C07594B5-5FD4-44A9-B60B-9D8B0906154C@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 09:59:39 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, this is also something where we should just disallow certain  
> system
> calls from being done through the asynchronous method.

Yeah.  Maybe just a bitmap built from __NR_ constants?  I don't know  
if we can do it in a way that doesn't require arch maintainer's  
attention.

It seems like it would be nice to avoid putting a test in the  
handlers themselves, and leave it up to the aio syscall submission  
processing.

> More interesting is the question about "close()", though. Currently we
> have an optimization (fget/fput_light) that basically boils down to  
> "we
> know we are the only owners". That optimization becomes more  
> "interesting"
> with AIO - we need to disable it when fibrils are active (because  
> other
> fibrils or the main thread can do it), but we can still keep it for  
> the
> non-fibril case.

I'll take a look, thanks for pointing it out.

- z
