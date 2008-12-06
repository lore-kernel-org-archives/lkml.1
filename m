Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbYLFOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbYLFOzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbYLFOyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:54:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:45341 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbYLFOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:54:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=sG9/MtUGuxYqDRfJuD8H8IHV4Ys1UnIaSpTdQrH5xlpnOWWvEO8+Vtm8O06AW898ux
         jc13OAJjGWJXWwv3y58kmQpzMFta1OHDMUlUT0NbXT1bb+vO9U1VgFQQpMGlTebM8rxl
         i09ayAlT9RGWh8A6Ng5ZFGzVqh+wpQvCUK0Dc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 5/6] ide-cd: move cdrom_timer_expiry to ide-atapi.c
Date: Sat, 6 Dec 2008 15:51:24 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com> <1228373010-20249-6-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1228373010-20249-6-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812061551.24745.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 04 December 2008, Borislav Petkov wrote:
> - cdrom_timer_expiry -> ide_cd_expiry
> - remove expiry-arg to ide_issue_pc as it is redundant now
> 
> There should be no functionality change resulting from this patch.

Well, there is a minor change actually: ide_debug_log -> debug_log.

> @@ -250,7 +251,38 @@ int ide_scsi_expiry(ide_drive_t *drive)
>  
>  	return 0; /* we do not want the IDE subsystem to retry */
>  }
> -EXPORT_SYMBOL_GPL(ide_scsi_expiry);

This seems to remove the symbol accidentally and although I've
just applied patch doing scheduled ide-scsi removal it would be
much better to take care of the core code's ide-scsi remnants
in separate patch(es).

> @@ -19,7 +19,6 @@
>  /*
>   * typical timeout for packet command
>   */
> -#define ATAPI_WAIT_PC		(60 * HZ)
>  #define ATAPI_WAIT_WRITE_BUSY	(10 * HZ)

The comment should be moved together with ATAPI_WAIT_PC define
(or removed).

The rest of the patch is fine.
