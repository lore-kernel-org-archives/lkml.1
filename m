Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZHFDvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZHFDvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZHFDvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:51:39 -0400
Received: from [222.73.24.84] ([222.73.24.84]:49750 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZHFDvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:51:38 -0400
Message-ID: <4A7A52EF.503@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 11:50:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 5/5] tracing/filters: Provide support for char *
 pointers
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-6-git-send-email-fweisbec@gmail.com> <4A768A87.6090800@cn.fujitsu.com> <20090805230257.GI5025@nowhere> <4A7A336B.4040708@cn.fujitsu.com> <20090806015949.GB24609@nowhere>
In-Reply-To: <20090806015949.GB24609@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How about add __field_type()? So we can define:
>>
>> 	__field_type(char *, str, FILTER_PTR_STR)
>>
>> the advantage is he who wrote the code really knows this field is safe
>> to be used in filtering as a string.
>>
>> I had some patches that does similar job. I can rewrite and post them.
> 
> Ah good idea. That may even be useful for further typedef'ed types which
> filter process match existing supported types.
> 

That's why I wrote those patches, to allow:

	# dev is type dev_t
	echo "dev == 8:0" > filter

	# callsite is void *
	echo "callsite == kfree_skb" > filter

> Just one neat however: __field_type looks too much ambiguous. __field() is
> already here to define a typed field. This seems confusing.
> 
> Why not __field_ext() for "extended"? We may probably add more flags
> than FILTER_PTR_STR in the future to define options for filtering or even
> for larger scope.
> 

Sure. You know I'm not good at naming. ;)

> I then wait for your patches to be posted and I'll integrate them in the
> current queue.
> 

Will soon be ready.

