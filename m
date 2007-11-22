Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbXKVETT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbXKVETT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 23:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXKVETJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 23:19:09 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:34337 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752885AbXKVETI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 23:19:08 -0500
X-Greylist: delayed 1054 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 23:19:08 EST
Date: Thu, 22 Nov 2007 07:19:52 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Dave Bailey <dsbailey@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Message-ID: <20071122041412.GB9896@rain>
Mail-Followup-To: Dave Bailey <dsbailey@pacbell.net>,
	linux-kernel@vger.kernel.org
References: <4743438F.3000904@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4743438F.3000904@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 12:29:03PM -0800, Dave Bailey wrote:
> This problem has been around since kernel 2.6.16, and I see it in
> 2.6.23.1-10.fc7. It occurs in the ufs_check_page function of ufs/dir.c
> at the Espan test, which seems unnecessary for NextStep/OpenStep
> files systems. The following patch preserves the test for other file
> systems and makes the mount useful for NextStep/OpenStep:
> (against the 2.6.23.1-10.fc7 source tree)
>
> dsb@Zeno-Dyn[1012]$ diff dir.c dir.c.orig
> 108,110d107
> <       unsigned mnext = UFS_SB(sb)->s_mount_opt &
> <         (UFS_MOUNT_UFSTYPE_NEXTSTEP || UFS_MOUNT_UFSTYPE_NEXTSTEP_CD ||
> <          UFS_MOUNT_UFSTYPE_OPENSTEP);
> 131c128
> <               if ((mnext == 0) & (((offs + rec_len - 1) ^ offs) & 
> ~chunk_mask))
> ---
> >               if (((offs + rec_len - 1) ^ offs) & ~chunk_mask)

This fixes only symptom, not illness.
This check represent what code think about filesystem layout.
On what actually kind of UFS system did you test this patch?
When I sometime ago fixed similar issue for openstep ufs,
actully this was darwin's ufs which has the same layout,
I just set s_dirblksize to right value, may be for 
UFS_MOUNT_UFSTYPE_NEXTSTEP, UFS_MOUNT_UFSTYPE_NEXTSTEP_CD you need
do the same, see TODO items in fs/ufs/super.c.

-- 
/Evgeniy

