Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbXKTUgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbXKTUgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761664AbXKTUgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:36:20 -0500
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:57239 "EHLO
	nlpi001.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761035AbXKTUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:36:18 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 15:36:17 EST
X-ORBL: [209.233.25.226]
Message-ID: <4743438F.3000904@pacbell.net>
Date: Tue, 20 Nov 2007 12:29:03 -0800
From: Dave Bailey <dsbailey@pacbell.net>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This problem has been around since kernel 2.6.16, and I see it in
2.6.23.1-10.fc7. It occurs in the ufs_check_page function of ufs/dir.c
at the Espan test, which seems unnecessary for NextStep/OpenStep
files systems. The following patch preserves the test for other file
systems and makes the mount useful for NextStep/OpenStep:
(against the 2.6.23.1-10.fc7 source tree)

dsb@Zeno-Dyn[1012]$ diff dir.c dir.c.orig
108,110d107
<       unsigned mnext = UFS_SB(sb)->s_mount_opt &
<         (UFS_MOUNT_UFSTYPE_NEXTSTEP || UFS_MOUNT_UFSTYPE_NEXTSTEP_CD ||
<          UFS_MOUNT_UFSTYPE_OPENSTEP);
131c128
<               if ((mnext == 0) & (((offs + rec_len - 1) ^ offs) & 
~chunk_mask))
---
 >               if (((offs + rec_len - 1) ^ offs) & ~chunk_mask)

