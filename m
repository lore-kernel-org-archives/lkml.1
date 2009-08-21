Return-Path: <linux-kernel-owner+w=401wt.eu-S1751880AbZHUAy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbZHUAy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZHUAy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:54:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60200 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbZHUAy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:54:27 -0400
Message-ID: <4A8DEFED.5090408@cn.fujitsu.com>
Date: Fri, 21 Aug 2009 08:53:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com> <20090820141400.f6d3d5a6.akpm@linux-foundation.org> <20090820163510.27942b62@bike.lwn.net> <alpine.DEB.2.00.0908201542440.29906@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0908201542440.29906@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 20 Aug 2009, Jonathan Corbet wrote:
> 
>> On Thu, 20 Aug 2009 14:14:00 -0700
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> Hang on.  Isn't this why Dave just wrote and I just rush-merged
>>> lib/flex_array.c?
>>>
>>> Was that code evaluated for this application and judged unsuitable?  If so,
>>> for what reason?
>> Should it be helpful: I wrote an overview of the flex_array API here:
>>
>> 	http://lwn.net/Articles/345273/
>>
>> I could format it up for addition to Documentation/ if people want.
>>
> 
> It's definitely helpful for this use case, flex array can store 261,632 
> pid_t's on 64 bit.
> 

flex_array surely can be used here, or implement Paul's proposal:
	http://lkml.org/lkml/2009/7/15/226

Note both solutions will probably make the output pid list unsorted.
Or maybe we can implement flex_array_sort().

