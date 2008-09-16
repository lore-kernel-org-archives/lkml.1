Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYIPPXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYIPPXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYIPPX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:23:28 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:43584 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbYIPPX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:23:27 -0400
From: Bodo Eggert <7eggert@gmx.de>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 16 Sep 2008 17:32:08 +0200
References: <bcGib-3Fp-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KfcXB-0003rP-6B@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> Protecting file->f_pos with a lock adds some overhead but I think we should
> fix this.
> I used seqlock to serialize the access to file->f_pos. This approach is
> similar to inode->i_size synchronization.
> 
> Comments?

> +             if (offset != file_pos_read(file))
> +                     file_pos_write(file, offset);

Maybe file_pos_write should do this check?

