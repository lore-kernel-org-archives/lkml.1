Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYDBMRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYDBMRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYDBMRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:17:25 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39472 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYDBMRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:17:24 -0400
Message-Id: <3AF481B79787436E8E20D6C597D5DD1C@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "David Chinner" <dgc@sgi.com>
Cc: <linux-kernel@vger.kernel.org>, <dm-devel@redhat.com>, <xfs@oss.sgi.com>,
       <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
References: <20080328180736t-sato@mail.jp.nec.com> <20080331000057.GI108924158@sgi.com> <2530BB4B166747659C8F65C9C3DE7CFB@nsl.ad.nec.co.jp> <20080402062147.GH103491721@sgi.com>
In-Reply-To: <20080402062147.GH103491721@sgi.com>
Subject: Re: [RFC PATCH 2/2] Add timeout feature
Date: Wed, 2 Apr 2008 21:16:59 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Chinner wrote:
>> Exactly my timeout feature is only for an application, not for
>> freeze_bdev().
>> I think it is needed for the situation we can't unfreeze from userspace.
>> (e.g. Freezing the root filesystem)
>
> Ummm - why can't you unfreeze the root fs from userspace? freezing
> only prevents modification to the filesystem. A frozen filesystem is
> effectively a read-only filesystem...
>
> On XFS:
>
> # xfs_freeze -f /
> # echo $?
> 0
> # xfs_freeze -u /
> # echo $?
> 0

Yes. If we have already logged in, we can unfreeze as above.
But if not, we cannot log in and unfreeze because the modification
of /var/log/wtmp is blocked in the log-in procedure.
The timeout feature will work in such case.

Cheers, Takashi
