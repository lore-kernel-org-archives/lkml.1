Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbYBZQjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbYBZQjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYBZQjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:39:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYBZQjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:39:05 -0500
Message-ID: <47C440A6.6080202@redhat.com>
Date: Tue, 26 Feb 2008 08:39:02 -0800
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Takashi Sato <t-sato@yk.jp.nec.com>
CC: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3 freeze feature ver 0.2
References: <20080219202706t-sato@mail.jp.nec.com> <20080226172014t-sato@mail.jp.nec.com>
In-Reply-To: <20080226172014t-sato@mail.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Sato wrote:

> o Elevate XFS ioctl numbers (XFS_IOC_FREEZE and XFS_IOC_THAW) to the VFS
>   As Andreas Dilger and Christoph Hellwig advised me, I have elevated
>   them to include/linux/fs.h as below.
>     #define FIFREEZE        _IOWR('X', 119, int)
> 　  #define FITHAW          _IOWR('X', 120, int)
>   The ioctl numbers used by XFS applications don't need to be changed.
>   But my following ioctl for the freeze needs the parameter
>   as the timeout period.  So if XFS applications don't want the timeout
>   feature as the current implementation, the parameter needs to be
>   changed 1 (level?) into 0.

So, existing xfs applications calling the xfs ioctl now will behave
differently, right?  We can only keep the same ioctl number if the
calling semantics are the same.  Keeping the same number but changing
the semantics is harmful, IMHO....

-Eric
