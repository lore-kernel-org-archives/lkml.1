Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbYA0Tfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbYA0Tfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbYA0Tce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:9418 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbYA0Tc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QTs7nHhLrrMcPkz4vqyQ1hhjWuuyWNMT0KvWtAZuiMaBo288Wx/nFCbQHQDTdrv44mq+mZI0DsQ1m9o/6mOL+IgWwZzRdS7tuzJfxHv67thtWTJZXPHzAHS4XyYLIrRP35OA2SmgFKbKt1uAiU22gcybGzYjb+4uSQNOeHNU5xM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 0/32] ide-tape redux v1
Date: Sun, 27 Jan 2008 20:45:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801272045.40712.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 27 January 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> after a lot of hammering ide-tape got pimped pretty considerably (ca. 600 lines
> shorter and slicker :)). I'm sure there's more to be done like, e.g. replacing

Good work. :)

> the BKL in idetape_write_release() with finer-grained locking etc, probably also
> some pipeline improvements, removal of OnStream support, etc. but that'll come
> later.

On-Stream support has been long gone but it seems that deprecation
warning etc. managed to survive.

w.r.t. to the pipeline-mode: it should be pipelined into /dev/null

rationale:
- it is _very_ complex
- causes errors to be deferred till the next user-space access
- direct I/O using blk_rq_map_user() will offer superior performance

the only question is whether to remove it...

>  Documentation/ide/ChangeLog.ide-tape.1995-2002 |  405 +++
>  drivers/ide/Kconfig                            |    3 +-
>  drivers/ide/ide-tape.c                         | 4146 +++++++++---------------
>  3 files changed, 1991 insertions(+), 2563 deletions(-)

applied #1-6, #8-9, #11-20, #29, #31

#10, #24 and #25 are also fine but since they depend on other patches
I couldn't merge them immediately

#7 and #21 need some recasting

#22 should be deferred for now

#26-28, #30 and #32 are still to be reviewed

BTW what happend to patch #23?

Thanks,
Bart
