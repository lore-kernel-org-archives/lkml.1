Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbYLUU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbYLUU6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 15:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYLUU5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 15:57:51 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56112 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYLUU5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 15:57:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fJVIK7Gp0Sv4ibirx+q5yvlgupjpXQQGgDGY8tKsC1Y/9ZAQZsXn6DN8K6LGq4ibU4
         LZns+tSycmeoC9Z/sT2QEombmh0Go4zh72Iyuuxi8MmE/LM7yVNWh3wG9Vx862c12j28
         OCGk78EXvv+oOA0si468nlpDFQ+0OS+nmDMjw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/8] ide-cd: first conversion batch
Date: Sun, 21 Dec 2008 20:05:56 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081219; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com> <200812192115.41068.bzolnier@gmail.com> <20081220062849.GA14770@gollum.tnic>
In-Reply-To: <20081220062849.GA14770@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812212005.56973.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 20 December 2008, Borislav Petkov wrote:
> Hi,
> 
> On Fri, Dec 19, 2008 at 09:15:40PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> [.. ]
> 
> > Yes, we don't want to move them over.  In worst case we can add
> > ide_handler_t *__old_pc_handler to ide_drive_t and set it in ide-cd
> > (an acceptable hack this time) but there might be better options.
> 
> Ok, here's the final patch moving ide-cd to the services of
> ide_(issue|transfer)_pc. The only change in functionality is that we

I merged the patchset (with 2 very minor fixups) but I think that this
one still needs some small preparatory changes first.

[ BTW I also merged outstanding ide patches.  Not many ide-{atapi,cd}
  changes in them though.  Thus if you prefer you may as well send me
  patches based on the old tree and let me handle potential rejects. ]

> don't do cdrom_decode_status for DRQ_INTERRUPT devices but this is
> probably not that relevant anymore since we busy-wait for DRQ to get set
> through ide_wait_stat, as we talked about it before - it being a bugfix for
> all atapi devices. If there's still interest for that (and I think it

Yes, this change is OK but for bisectability reasons it would be better
to do it in pre-patch (which would fix ide-cd.c accordingly).

[ The other changes in functionality are small and acceptable for this
  patch (i.e. ide_wait_stat() prints error message now) except the change
  of the ordering between ->dma_start and ->output_data calls -- which
  also seems to deserve patch on its own. ]

Otherwise it all looks fine and Big Thanks for working on this!
