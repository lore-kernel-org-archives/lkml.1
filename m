Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZCDHYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZCDHYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZCDHX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:23:56 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:59877 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZCDHXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:23:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=BveNYzvrRGjoZQoSongQVsw59Cc5l0kJhjA3KyC/sZkW3wnx0remtGx80IHfka0Oeg
         QFvZ06lLPQ1y/ZNDPu1BEc1ULNmSLRzrYZIol4qWdzdxSeV6LbUWf0jzAFP0Ri12+ww3
         XqMyyhWe/W0DMDbpXXJC8IOFBLQiScPkcP0ZI=
Date: Wed, 4 Mar 2009 08:23:47 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux-next-20090225: ide-cd triggers BUG at
	arch/x86/mm/ioremap.c:80!
Message-ID: <20090304072347.GB3273@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp> <200903020215.n222FBpu067502@www262.sakura.ne.jp> <9ea470500903020515p4c4e5b9cu74c174a43bd4df3c@mail.gmail.com> <200903021627.23585.bzolnier@gmail.com> <20090303083506.GA5172@liondog.tnic> <200903040333.n243XE0m014406@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200903040333.n243XE0m014406@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 12:33:14PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Borislav Petkov wrote:
> > how about something like that:
> > 
> > We map to sg once in ide_issue_pc since all drivers call into that.
> > We have to exclude ide_tape for now since it doesn't do that and uses
> > its own io buffers-method. Then, we do for both ide-cd and ide-floppy
> > blk_rq_bytes(rq) in ide_init_sg_cmd() after I've fixed the partial
> > completions issue later.
> > 
> > Lightly tested with ide-cd for now.
> > 
> > @Tetsuo: please do test, this should fix your OOPS.
> > 
> OK. This patch solved the problem.
> 
> Thank you.

Hi,

Thanks a lot for patiently testing for us.


-- 
Regards/Gruss,
    Boris.
