Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYLSUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYLSUk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYLSUkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:40:19 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35102 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYLSUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:40:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WX4/oy7aE6dnh6ELla4uAE3+ApjyocESkmr6TwiTcpgH6DmXASkNAUtZTzFCLPdHfv
         xJNGSQfE3qZb22U7f4JzfeLEjFTSZXr7RTHck0V0g68RCY9shRDqHR8Z7MRmeXlVOITP
         NDHeVthinyLGY8isdfwBg4XQiakD583gZdSg0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/8] ide-cd: first conversion batch
Date: Fri, 19 Dec 2008 21:15:40 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081219; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812192115.41068.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 18 December 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's the first batch of conversion patches. Now ide_issue_pc/ide_transfer_pc
> are almost completely aligned to their ide-cd counterparts
> cdrom_start_packet_command/cdrom_transfer_packet_command. The only thing

Looks good generally but I need more time for detailed review.

[ Your super-quick action on this has caught me unprepared. ;) ]

> missing is the setting of the irq handler through ide_set_handler but this
> is not that trivial since if i'd moved ide-cd's irq handler to ide-atapi
> that would suck in a bunch of other ide-cd functions which is not what we
> want, (yes/no)? and I'm going to have to ponder a little bit more on that.

Yes, we don't want to move them over.  In worst case we can add
ide_handler_t *__old_pc_handler to ide_drive_t and set it in ide-cd
(an acceptable hack this time) but there might be better options.

Thanks,
Bart
