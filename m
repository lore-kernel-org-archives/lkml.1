Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYDCT2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYDCT2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYDCT2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:28:24 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38249 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYDCT2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:28:23 -0400
Message-ID: <47F52FC0.60305@linux.vnet.ibm.com>
Date: Fri, 04 Apr 2008 00:58:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain> <1207247113.21922.63.camel@nimitz.home.sr71.net> <47F52735.7090502@linux.vnet.ibm.com> <6599ad830804031156w79366866yed9f8c3b8acf71fb@mail.gmail.com>
In-Reply-To: <6599ad830804031156w79366866yed9f8c3b8acf71fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Apr 3, 2008 at 11:51 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  >> +     * delay_group_leader() ensures that if the group leader is around
>>  >> +     * we need not select a new owner.
>>  >> +     */
>>  >> +    ret = (mm && (atomic_read(&mm->mm_users) > 1) && (mm->owner == p) &&
>>  >> +            !delay_group_leader(p));
>>  >> +    return ret;
>>  >> +}
>>  >
>>  > Ugh.  Could you please spell this out a bit more.  I find that stuff
>>  > above really hard to read.  Something like:
>>  >
>>  >       if (!mm)
>>  >               return 0;
>>  >       if (atomic_read(&mm->mm_users) <= 1)
>>  >               return 0;
>>  >       if (mm->owner != p)
>>  >               return 0;
>>  >       if (delay_group_leader(p))
>>  >               return 0;
>>  >       return 1;
>>  >
>>
>>  The problem with code above is 4 branch instructions and the code I have just 4
>>  AND operations.
> 
> They'll be completely equivalent to the compiler, due to the
> short-circuit evaluation of &&

Aahh.. Yes.. my bad.. I keep under-estimating compilers and their potential to
optimize

Form (2) seems more readable, I'll move to that



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
