Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYEGBrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYEGBrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYEGBrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:47:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYEGBrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:47:31 -0400
Message-ID: <482109E5.5050204@cn.fujitsu.com>
Date: Wed, 07 May 2008 09:46:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
References: <48210101.1070205@google.com> <20080506183841.e1771032.akpm@linux-foundation.org>
In-Reply-To: <20080506183841.e1771032.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 May 2008 18:08:17 -0700 Paul Menage <menage@google.com> wrote:
> 
>> -static int update_relax_domain_level(struct cpuset *cs, char *buf)
>> +static int update_relax_domain_level(struct cpuset *cs, s64 val)
>>  {
>> -	int val = simple_strtol(buf, NULL, 10);
>> -
>> -	if (val < 0)
>> +	if ((int)val < 0)
>>  		val = -1;
>>  
> 
> Are you sure about the typecast here?  If `val' has a value of say
> 0x0000_ffff_ffff_ffff then I assume the casted value will be negative, only
> it wasn't?
> 

I saw this, but I think it's ok.

  -1  : no request. use system default or follow request of others.
   0  : no search.
  ...
 ( 5~ : search system wide [on NUMA system])

Or maybe we can restrict the value from -1 to 5 ?
