Return-Path: <linux-kernel-owner+w=401wt.eu-S1422957AbXBAUFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957AbXBAUFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422972AbXBAUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:05:13 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:45707 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422957AbXBAUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:05:12 -0500
Message-ID: <45C247EB.6000806@namesys.com>
Date: Thu, 01 Feb 2007 23:04:59 +0300
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-list@namesys.com,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc3-mm1: umount reiser4 FS stuck in D state
References: <20070104220200.ae4e9a46.akpm@osdl.org> <200701062158.06329.vs@namesys.com> <45A81231.6040104@free.fr> <200701231940.58053.vs@namesys.com> <20070123154617.GE11995@kernel.dk> <45B65234.4000203@free.fr>
In-Reply-To: <45B65234.4000203@free.fr>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:

> Le 23.01.2007 16:46, Jens Axboe a écrit :
>
>> On Tue, Jan 23 2007, Vladimir V. Saveliev wrote:
>>
>>> Hello
>>>
>>> On Saturday 13 January 2007 01:56, Laurent Riffard wrote:
>>>
>>>> Le 06.01.2007 19:58, Vladimir V. Saveliev a écrit :
>>>>
>>>>> Hello
>>>>>
>>>>> On Saturday 06 January 2007 13:58, Laurent Riffard wrote:
>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> got this with 2.6.20-rc3-mm1:
>>>>>>
>>>>>> =======================
>>>>>> SysRq : Show Blocked State
>>>>>>
>>>>>>                          free                        sibling
>>>>>>   task             PC    stack   pid father child younger older
>>>>>> umount        D C013135E  6044  1168   1150                     
>>>>>> (NOTLB)
>>>>>>        de591ae4 00000086 de591abc c013135e dff979c8 c012a6fe 
>>>>>> 00000046 00000007        dfd94ac0 128d3000 00000026 00000000 
>>>>>> dfd94bcc dff979c8 de591ae4 dffda038        00000002 dff979c0 
>>>>>> dff979bc dff979c8 de591b10 c012d600 dff979f8 00000000 Call Trace:
>>>>>>  [<c012d600>] synchronize_qrcu+0x70/0x8c
>>>>>>  [<c01bede4>] __make_request+0x4c/0x29b
>>>>>>  [<c01bd24b>] generic_make_request+0x1b0/0x1de
>>>>>>  [<c01bf354>] submit_bio+0xda/0xe2
>>>>>>  [<e12674bd>] write_jnodes_to_disk_extent+0x920/0x974 [reiser4]
>>>>>>  [<e12678dd>] update_journal_footer+0x29f/0x2b7 [reiser4]
>>>>>>  [<e1268b65>] write_tx_back+0x149/0x185 [reiser4]
>>>>>>  [<e126a8e7>] reiser4_write_logs+0xea4/0xfd2 [reiser4]
>>>>>>  [<e125626a>] try_commit_txnh+0x7e6/0xa4f [reiser4]
>>>>>>  [<e125661b>] reiser4_txn_end+0x148/0x3cf [reiser4]
>>>>>>  [<e12568ad>] reiser4_txn_restart+0xb/0x1a [reiser4]
>>>>>>  [<e125692f>] reiser4_txn_restart_current+0x73/0x75 [reiser4]
>>>>>>  [<e1256b89>] force_commit_atom+0x258/0x261 [reiser4]
>>>>>>  [<e1257703>] txnmgr_force_commit_all+0x406/0x697 [reiser4]
>>>>>>  [<e12e5e08>] release_format40+0x10c/0x193 [reiser4]
>>>>>>  [<e1279922>] reiser4_put_super+0x134/0x16a [reiser4]
>>>>>>  [<c015c930>] generic_shutdown_super+0x55/0xd8
>>>>>>  [<c015c9d3>] kill_block_super+0x20/0x32
>>>>>>  [<c015ca75>] deactivate_super+0x3f/0x51
>>>>>>  [<c016d903>] mntput_no_expire+0x42/0x5f
>>>>>>  [<c0160f37>] path_release_on_umount+0x15/0x18
>>>>>>  [<c016df77>] sys_umount+0x1a3/0x1cb
>>>>>>  [<c016dfb8>] sys_oldumount+0x19/0x1b
>>>>>>  [<c0103ed2>] sysenter_past_esp+0x5f/0x99
>>>>>>  =======================
>>>>>>
>>>>>> Scenario:
>>>>>> - umount a reiser4 FS (no need to write something before)
>>>>>
>>>>> Hmm, I can not reproduce this with 2.6.20-rc3-mm1. Probably I need 
>>>>> to config the kernel more close to your system.
>>>>>
>>>>>> Earlier kernels were OK.
>>>>>
>>>> This still happens with 2.6.20-rc4-mm1...
>>>>
>>>> Should I open a bug report at http://bugzilla.kernel.org?
>>>>
>>> Which device with reiser4 did you try to umount?  Jens wrote that it
>>> could be a barrier related. If there are no multidevices involved -
>>> please report to bugzilla.
>>
>>
>> Make sure that your kernel contains this fix:
>>
>> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=4af09c42ee1af70356471f51c1f40c1ff7881b68;hp=036f6008f43b5b4dd8c825365f15434d75005c6d 
>>
>>
>> I think it missed 2.6.20-rc3-mm1. Again, that assumes you are using md
>> or dm.
>
>
> I've got 2 reiser4 FS:
> - one with /dev/sdb6
> - the other with /dev/vglinux1/ccache (vglinux1 is built on /dev/sda4 
> and /dev/sdb7).
> There is no md here, only dm.
>
> I applied the above patch on top of 2.6.20-rc4-mm1, but the problem 
> still happens with the two devices.
>
> thanks

Laurent, would you please try 2.6.20-rc6-mm3 + this patch:
http://lkml.org/lkml/diff/2007/2/1/195/1

Thanks,
Edward.
