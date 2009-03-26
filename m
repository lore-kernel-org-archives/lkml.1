Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZCZCNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZCZCNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZCZCNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:13:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCZCNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:13:11 -0400
Message-ID: <49CAE4CB.3050000@cn.fujitsu.com>
Date: Thu, 26 Mar 2009 10:13:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk>
In-Reply-To: <20090325101747.GL27476@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Mar 25 2009, Ingo Molnar wrote:
>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> Currently the original blktrace, which is using relay and is used 
>>> via ioctl, is broken. You can use ftrace to see the output of 
>>> blktrace, but user-space blktrace is unusable.
>> good catch, thanks Li!
>>
>> Jens, Arnaldo, do these fixes look good to you too?
> 
> Look fine, but I'm very worried about the state of the current code. I
> mean, this last round of fixes got the timestamp correct and made
> blktrace work again. Those are something that should have been caught
> even before the whole thing was posted, let alone merged. When do you
> plan on pushing this upstream? Looks like 2.6.31 to me, it's clearly not
> ready for 2.6.30 by any stretch.
> 

Actually not all the bugs I found are introduced by "blktrace: ftrace plugin"
in -tip tree.

One is introduced by "block: get rid of the manual directory counting in blktrace"
(f48fc4d32e24c0b6a18aad30305d819bcc68c049). Two are "blktrace: port to tracepoints"
(5f3ea37c7716db4e894a480e0c18b24399595b6b). Both commits are in mainline.

Since 2 of the bugs will rarely happen in real-life, and the 3rd one is a small
issue, and we were so close to the release of .29, so I sent the fixes for -tip
tree but not mainline. But if we are going merge tip/blktrace to .31, I guess
it's better to merge that 3 fixes to .30?
