Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZGVCcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZGVCcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZGVCcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:32:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZGVCcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:32:24 -0400
Message-ID: <4A667A2E.9070206@redhat.com>
Date: Wed, 22 Jul 2009 10:32:14 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <6599ad830907210903q7206cac2l83a9139d19c5e1a@mail.gmail.com> <4A667218.7040105@redhat.com> <4A6676F4.7070201@cn.fujitsu.com>
In-Reply-To: <4A6676F4.7070201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 10:18 AM, Li Zefan wrote:
> Danny Feng wrote:
>> On 07/22/2009 12:03 AM, Paul Menage wrote:
>>> On Tue, Jul 21, 2009 at 3:25 AM, Xiaotian Feng<dfeng@redhat.com>   wrote:
>>>> In cgroup_get_sb, the lock sequence is:
>>>>          mutex_lock(&inode->i_mutex);
>>>>          mutex_lock(&cgroup->mutex);
>>>> so the last unlock sequence should be:
>>> Make this "so for consistency the last ..." ?
>>>
>>> Maybe make the patch title "Make unlock sequence in cgroup_get_sb
>>> consistent" so someone looking through the change logs for fixes to
>>> backport doesn't wrongly thing that this fixes any bug"?
>>>
>> Yep, this is a trivial patch.  Modified following your suggestion, thank
>> you.
>>
>
> As far as it's not declared as a fix, I has no objection to this
> patch.
>
> Please always inline the patch in the mail body. And when resending
> the patch, add the acked-by you collected in it:
>
> Acked-by: Balbir ...
> Acked-by: Paul ...
> Signed-off-by: Xiaotian ...
>
> You may resend the patch to Andrew Morton, who picks up cgroup
> patches, otherwise the patch may be overlooked.
>
Got it, thank you very much.
>>>>          mutex_unlock(&cgroup->mutex);
>>>>          mutex_unlock(&inode->i_mutex);
>>>>
>>>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>>> Acked-by: Paul Menage<menage@google.com>
>>>
>>> Paul
>

