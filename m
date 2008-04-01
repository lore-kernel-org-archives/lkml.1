Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYDAIzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYDAIzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYDAIzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:55:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61752 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYDAIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:55:46 -0400
Message-ID: <47F1F7A6.5020105@yandex.ru>
Date: Tue, 01 Apr 2008 11:51:50 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>         <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>
In-Reply-To: <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 08:55:40.0255 (UTC) FILETIME=[2923B6F0:01C893D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>>  +config UBIFS_FS_DEBUG_MSG_GEN
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_JRN
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_CMT
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_BUDG
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_LOG
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_TNC
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_LP
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_FIND
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_MNT
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_IO
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_GC
>>  +
>>  +config UBIFS_FS_DEBUG_MSG_SCAN
> 
> But these don't make much sense to me. Why would you want to be able
> to compile out printks at this granularity? Why not enable all of them
> when CONFIG_UBIFS_FS_DEBUG is enabled?

Well, its just more convenient for us. If I know the bug is somewhere in
the journal, I enable the journal messages - less flooding. We may
lessen the amount, but it is still handy to have some classes of
prints separate.

We will think how to lessen the amount and granularity of this.

> 
>>  +menu "Extra self-checks"
>>  +       depends on UBIFS_FS_DEBUG
>>  +
>>  +config UBIFS_FS_DEBUG_CHK_MEMPRESS
> 
>>  +config UBIFS_FS_DEBUG_CHK_LPROPS
>>  +
>>  +config UBIFS_FS_DEBUG_CHK_TNC
>>  +
>>  +config UBIFS_FS_DEBUG_CHK_ORPH
>>  +
>>  +config UBIFS_FS_DEBUG_CHK_IDX_SZ
>>  +
>>  +config UBIFS_FS_DEBUG_CHK_OLD_IDX
>>  +
>>  +config UBIFS_FS_DEBUG_CHK_OTHER
>>  +
>>  +config UBIFS_FS_DEBUG_TEST_RCVRY
> 
> Why would you not want to enable all of these for development kernels?

Some of the checks are very heavy-weight. For example, the tree checking
functions scan the whole TNC/LPT B-tree, which means they read it from
flash, they check CRC, and they make sure the tree is consistent and
has sane data. They are very useful when hunting bugs, but they are too
slow to be always enabled.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
