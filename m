Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbXA3Wxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbXA3Wxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXA3Wxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:53:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33244 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXA3Wxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:53:43 -0500
X-Greylist: delayed 750 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 17:53:43 EST
In-Reply-To: <Pine.LNX.4.64.0701301416250.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org> <Pine.LNX.4.64.0701301416250.3611@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <23588500-5AD3-48E1-A6F7-679E9DC9C4FC@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Tue, 30 Jan 2007 14:53:18 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So we should limit these to basically have some maximum concurrency
> factor, but rather than consider it an error to go over it, we'd  
> just cap
> the concurrency by default, so that people can freely use asynchronous
> interfaces without having to always worry about what happens if their
> resources run out..

Yeah, call it the socket transmit queue model :).  Maybe tuned by a  
ulimit?

I don't have very strong opinions abou the specific mechanics of  
limiting concurrent submissions, as long as they're there.  Some  
folks in Oracle complain about having one more thing to have to tune,  
but the alternative seems worse.

> However, that also implies that we should probably add a "flags"  
> parameter
> to "async_submit()" and have a FIBRIL_IMMEDIATE flag (or a timeout) or
> something to tell the kernel to rather return EAGAIN than wait.  
> Sometimes
> you don't want to block just because you already have too much work.

EAGAIN or the initial number of submissions completed before the one  
that ran over the limit, perhaps.  Sure.  Nothing too controversial  
here :).   I have this kind of stuff queued up for worrying about  
once the internal mechanics are stronger.

- z

