Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYGHB3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYGHB3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 21:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYGHB3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 21:29:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbYGHB3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 21:29:32 -0400
Message-ID: <4872C299.8060207@cn.fujitsu.com>
Date: Tue, 08 Jul 2008 09:27:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 1/2] devcgroup: always show unsigned major/minor num
References: <486F0918.5090707@cn.fujitsu.com> <6599ad830807071213u7334cafanc6f2a0b7c4f53ba2@mail.gmail.com>
In-Reply-To: <6599ad830807071213u7334cafanc6f2a0b7c4f53ba2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Jul 4, 2008 at 10:39 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>  # echo "b $((0x7fffffff)):$((0x80000000)) rwm" > devices.allow
>>  # cat devices.list
>>  b 214748364:-21474836 rwm
>>
>> though a major/minor number of 0x800000000 is meaningless, we
>> should not cast it to a negative value.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  security/device_cgroup.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
>> index fd764a0..1e2e28a 100644
>> --- a/security/device_cgroup.c
>> +++ b/security/device_cgroup.c
>> @@ -222,7 +222,7 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
>>  #define DEVCG_DENY 2
>>  #define DEVCG_LIST 3
>>
>> -#define MAJMINLEN 10
>> +#define MAJMINLEN 13
>>  #define ACCLEN 4
>>
>>  static void set_access(char *acc, short access)
>> @@ -254,7 +254,7 @@ static void set_majmin(char *str, unsigned m)
>>        if (m == ~0)
>>                sprintf(str, "*");
> 
> Can't this just be strcat(str, "*")?
> 

No, but it can be strcpy(str, "*").

>>        else
>> -               snprintf(str, MAJMINLEN, "%d", m);
>> +               snprintf(str, MAJMINLEN, "%u", m);
> 
> I'm not sure that using snprintf() helps here over just sprintf() -
> we're not actually basing it on the available space in the string,
> we're just assuming there's enough space.
> 

Agreed. 
