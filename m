Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbYALUVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbYALUVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762001AbYALUUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:20:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:20839 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbYALUUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FAaaJKA09oxcYwhH8iw1u0Uj7Q2KReoJeFWbLhku6vPLGdf3rCyi7gEq+Y+qy2lvh9gxM3tAWh7BRoUbuRsvZVx/kJVqFoBionDu6CFs5CnxQjn0gakiEJVEJkAHAbycrQFj0VphrY+sgg/Ew+p7n54fzDmvHjCz05JrnYPRswc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 20/21] ide-floppy: merge idefloppy_{input,output}_buffers
Date: Sat, 12 Jan 2008 21:19:16 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-20-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-21-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-21-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801122119.16517.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> We merge idefloppy_{input,output}_buffers() into idefloppy_io_buffers() by
> introducing a 4th arg. called direction. According to its value
> we atapi_input_bytes() or atapi_output_bytes(). Also, simplify the interrupt

This change is fine but ...

> handler by removing multiple calls testing the data direction and using a local
> variable instead.

... the patch replaces 'test_bit(PC_WRITING, &pc->flags)' check with
'rq_data_dir(rq) == WRITE' one.  While this may look as "trivial" change it
is not such.  It should be done only after auditing the driver and making
sure that we are not introducing subtle regressions (=> I see that some
commands are setting PC_WRITING but are not setting REQ_RW bit), especially
given that these changes were not tested with the real hardware.

Please separate this change to another (post-)patch.

PS It would also be nice to remove IDEFLOPPY_DEBUG_BUGS define in a pre-patch.
