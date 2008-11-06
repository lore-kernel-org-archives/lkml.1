Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYKFMof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYKFMof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYKFMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:44:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40715 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYKFMoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:44:25 -0500
Message-ID: <29542.10.75.179.61.1225975461.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20081106202534.80e5cf0a.nishimura@mxp.nes.nec.co.jp>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com><20081105172141.1a12dc23.kamezawa.hiroyu@jp.fujitsu.com>
    <20081106202534.80e5cf0a.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 6 Nov 2008 21:44:21 +0900 (JST)
Subject: Re: [RFC][PATCH 4/6] memcg : swap cgroup
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> On Wed, 5 Nov 2008 17:21:41 +0900, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Note1: In this, we use pointer to record information and this means
>>       8bytes per swap entry. I think we can reduce this when we
>>       create "id of cgroup" in the range of 0-65535 or 0-255.
>>
>> Note2: array of swap_cgroup is allocated from HIGHMEM. maybe good for
>> x86-32.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>  include/linux/page_cgroup.h |   35 +++++++
>>  mm/page_cgroup.c            |  201
>> ++++++++++++++++++++++++++++++++++++++++++++
>>  mm/swapfile.c               |    8 +
>>  3 files changed, 244 insertions(+)
>>
> Is there any reason why they are defined not in memcontrol.[ch]
> but in page_cgroup.[ch]?
>
no strong reason. just because this is not core logic for acccounting.
do you want to see this in memcontrol.c ?

>> +void swap_cgroup_swapoff(int type)
>> +{
>> +	int i;
>> +	struct swap_cgroup_ctrl *ctrl;
>> +
>> +	if (!do_swap_account)
>> +		return;
>> +
>> +	mutex_lock(&swap_cgroup_mutex);
>> +	if (ctrl->map) {
>> +		ctrl = &swap_cgroup_ctrl[type];
> This line should be before "if (ctrl->map)"(otherwise "ctrl" will be
> undefined!).
>
Oh....maybe refresh mis...brame me.

Thanks,
-Kame


