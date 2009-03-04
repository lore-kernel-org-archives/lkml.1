Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZCDDda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZCDDda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZCDDdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:33:22 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56985 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZCDDdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:33:21 -0500
Message-Id: <200903040333.n243XE0m014406@www262.sakura.ne.jp>
Subject: Re: linux-next-20090225: ide-cd triggers BUG at arch/x86/mm/ioremap.c:80!
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: petkovbb@gmail.com
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Mar 2009 12:33:14 +0900
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp> <200903020215.n222FBpu067502@www262.sakura.ne.jp> <9ea470500903020515p4c4e5b9cu74c174a43bd4df3c@mail.gmail.com> <200903021627.23585.bzolnier@gmail.com> <20090303083506.GA5172@liondog.tnic>
In-Reply-To: <20090303083506.GA5172@liondog.tnic>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 04032009 #1686003, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:
> how about something like that:
> 
> We map to sg once in ide_issue_pc since all drivers call into that.
> We have to exclude ide_tape for now since it doesn't do that and uses
> its own io buffers-method. Then, we do for both ide-cd and ide-floppy
> blk_rq_bytes(rq) in ide_init_sg_cmd() after I've fixed the partial
> completions issue later.
> 
> Lightly tested with ide-cd for now.
> 
> @Tetsuo: please do test, this should fix your OOPS.
> 
OK. This patch solved the problem.

Thank you.
