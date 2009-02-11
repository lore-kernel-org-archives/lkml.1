Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZBKKuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZBKKuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZBKKuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:50:07 -0500
Received: from main.gmane.org ([80.91.229.2]:38327 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbZBKKuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:50:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Date: Wed, 11 Feb 2009 11:44:01 +0100
Message-ID: <4992ABF1.3080007@redhat.com>
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz> <20090203133251.GD29046@elte.hu> <gmeu0q$n13$1@ger.gmane.org> <20090209131354.GC3205@nb.net.home> <49902E57.5000406@redhat.com> <20090209135431.GD3205@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p578ffed9.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
In-Reply-To: <20090209135431.GD3205@nb.net.home>
Cc: power@bughost.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> On Mon, Feb 09, 2009 at 02:23:35PM +0100, Harald Hoyer wrote:
>> Karel Zak wrote:
>>> On Thu, Feb 05, 2009 at 03:44:42PM +0100, Harald Hoyer wrote:
>>>> Ingo Molnar wrote:
>>>>> * Pavel Machek <pavel@suse.cz> wrote:
>>>>>
>>>>>> On Tue 2009-01-27 12:08:04, Kok, Auke wrote:
>>>>>>> This tracer monitors regular file open() syscalls. This is a fast
>>>>>>> and low-overhead alternative to strace, and does not allow or
>>>>>>> require to be attached to every process.
>>>>>>>
>>>>>>> The tracer only logs succesfull calls, as those are the only ones we
>>>>>>> are currently interested in, and we can determine the absolute path
>>>>>>> of these files as we log.
>>>>>> Maybe fanotify() should be used instead?
>>>>>>
>>>>>> Or maybe just plain strace? One slow boot should not really hurt...
>>>>> ptrace is out of question for good tracing because it's not a  
>>>>> transparent probe. (ptrace monopolizes the traced task - if we use 
>>>>> that then we break regular strace usage.)
>>>>>
>>>>> 	Ingo
>>>> Can strace can be used on init?
>>>>
>>>> $ man strace
>>>> ...
>>>>        On Linux, exciting as it would be, tracing the init process is forbidden.
>>>> ...
>>>>
>>>> Any hope getting _any_ mechanism in the kernel??
>>>  Do you remember Linux Auditing System? That's RH's baby with hooks to
>>>  all relevant syscalls. It would be better to fix/improve the current
>>>  kernel mechanisms that introduce a new one.
>> Yes, I do remember it, because this is how the current fedora readahead
>> gathers its data. It delays the audit daemon, because there is no clean 
>> way to hook into the stream. I asked to add a second "channel" (auditd 
>> wants the kernel socket for its own)...
> 
>  yes, it'd be nice to support arbitrary number of connections and
>  rules per connection. (.. or export audit stuff to userspace by a
>  special pseudo filesystem (see cgroups, debugfs, ...)).
> 
>     Karel
> 

right! if only someone would implement that *hint, hint* :-/

