Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbYEUBYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbYEUBYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbYEUBY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:24:29 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53510 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011AbYEUBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:24:27 -0400
Message-Id: <1AE3C150C90A4C1A8C024C3D6079C948@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Andreas Dilger" <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>, <dm-devel@redhat.com>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20080514170625t-sato@mail.jp.nec.com> <20080520035712.GA7252@webber.adilger.int>
In-Reply-To: <20080520035712.GA7252@webber.adilger.int>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Wed, 21 May 2008 10:23:23 +0900
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

Andreas Dilger wrote:
>> +static int ioctl_freeze(struct file *filp)
>> +{
>> +    struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +
>> +    if (!capable(CAP_SYS_ADMIN))
>> +        return -EPERM;
>> +
>> +    /* If filesystem doesn't support freeze feature, return. */
>> +    if (sb->s_op->write_super_lockfs == NULL)
>> +        return -EINVAL;
> 
> Should this be EINVAL, or EOPNOTSUPP?  Usually EINVAL means there is
> something wrong with the passed ioctl parameters (e.g. bad value),
> while EOPNOTSUPP is "operation not supported" and makes more sense.

Sounds good.
I will send new patch-set which is rebased to 2.6.26-rc3 and includes
this fix, in this weekend.

Cheers, Takashi
