Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZBINyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZBINyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZBINyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:54:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbZBINyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:54:35 -0500
Date: Mon, 9 Feb 2009 14:54:31 +0100
From: Karel Zak <kzak@redhat.com>
To: Harald Hoyer <harald@redhat.com>
Cc: linux-kernel@vger.kernel.org, power@bughost.org
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090209135431.GD3205@nb.net.home>
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz> <20090203133251.GD29046@elte.hu> <gmeu0q$n13$1@ger.gmane.org> <20090209131354.GC3205@nb.net.home> <49902E57.5000406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49902E57.5000406@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 02:23:35PM +0100, Harald Hoyer wrote:
> Karel Zak wrote:
>> On Thu, Feb 05, 2009 at 03:44:42PM +0100, Harald Hoyer wrote:
>>> Ingo Molnar wrote:
>>>> * Pavel Machek <pavel@suse.cz> wrote:
>>>>
>>>>> On Tue 2009-01-27 12:08:04, Kok, Auke wrote:
>>>>>> This tracer monitors regular file open() syscalls. This is a fast
>>>>>> and low-overhead alternative to strace, and does not allow or
>>>>>> require to be attached to every process.
>>>>>>
>>>>>> The tracer only logs succesfull calls, as those are the only ones we
>>>>>> are currently interested in, and we can determine the absolute path
>>>>>> of these files as we log.
>>>>> Maybe fanotify() should be used instead?
>>>>>
>>>>> Or maybe just plain strace? One slow boot should not really hurt...
>>>> ptrace is out of question for good tracing because it's not a  
>>>> transparent probe. (ptrace monopolizes the traced task - if we use 
>>>> that then we break regular strace usage.)
>>>>
>>>> 	Ingo
>>> Can strace can be used on init?
>>>
>>> $ man strace
>>> ...
>>>        On Linux, exciting as it would be, tracing the init process is forbidden.
>>> ...
>>>
>>> Any hope getting _any_ mechanism in the kernel??
>>
>>  Do you remember Linux Auditing System? That's RH's baby with hooks to
>>  all relevant syscalls. It would be better to fix/improve the current
>>  kernel mechanisms that introduce a new one.
>
> Yes, I do remember it, because this is how the current fedora readahead
> gathers its data. It delays the audit daemon, because there is no clean 
> way to hook into the stream. I asked to add a second "channel" (auditd 
> wants the kernel socket for its own)...

 yes, it'd be nice to support arbitrary number of connections and
 rules per connection. (.. or export audit stuff to userspace by a
 special pseudo filesystem (see cgroups, debugfs, ...)).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
