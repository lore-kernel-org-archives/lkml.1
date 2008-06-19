Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYFSAo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYFSAo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbYFSAov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:44:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbYFSAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:44:50 -0400
Message-ID: <4859ABA6.4000904@cn.fujitsu.com>
Date: Thu, 19 Jun 2008 08:43:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cgroup: support checking of subsystem dependencies
References: <4858C0ED.2080905@cn.fujitsu.com> <6599ad830806181413y5d0ef1bfyfc54c17ee904d744@mail.gmail.com>
In-Reply-To: <6599ad830806181413y5d0ef1bfyfc54c17ee904d744@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>  {
>>        int ret = 0;
>> @@ -852,6 +871,10 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>        if (ret)
>>                goto out_unlock;
>>
>> +       ret = check_subsys_dependency(opts.subsys_bits);
>> +       if (ret)
>> +               goto out_unlock;
>> +
> 
> Can we just call this from one place, in parse_cgroupfs_options() ?
> 

I think yes we can. I'll revise it.

