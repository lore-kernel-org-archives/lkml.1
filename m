Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZJBVGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZJBVGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZJBVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:06:37 -0400
Received: from smtp171.iad.emailsrvr.com ([207.97.245.171]:53776 "EHLO
	smtp171.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZJBVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:06:36 -0400
Message-ID: <4AC66B5E.9060200@librato.com>
Date: Fri, 02 Oct 2009 17:06:38 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
References: <20090924165548.GA16586@us.ibm.com> <20090924175542.GA27678@x200> <20090924183556.GA31356@us.ibm.com> <20090930053443.GA1010@x200> <4AC39859.3090703@librato.com> <20091002202759.GA4826@x200>
In-Reply-To: <20091002202759.GA4826@x200>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> On Wed, Sep 30, 2009 at 01:41:45PM -0400, Oren Laadan wrote:
>> Alexey Dobriyan wrote:
>>> On Thu, Sep 24, 2009 at 01:35:56PM -0500, Serge E. Hallyn wrote:
>>>> Quoting Alexey Dobriyan (adobriyan@gmail.com):
>>>>> I don't like this even more.
>>>>>
>>>>> Pid namespaces are hierarchical _and_ anonymous, so simply
>>>>> set of numbers doesn't describe the final object.
>>>>>
>>>>> struct pid isn't special, it's just another invariant if you like
>>>>> as far as C/R is concerned, but system call is made special wrt pids.
>>>>>
>>>>> What will be in an image? I hope "struct kstate_image_pid" with several
>>>> Sure pid namespaces are anonymous, but we will give each an 'objref'
>>>> valid only for a checkpoint image, and store the relationship between
>>>> pid namespaces based on those objrefs.  Basically the same way that user
>>>> structs and hierarchical user namespaces are handled right now.
>>> OK, that's certainly doable.
>>>
>>> You're commiting yourself to creation of tasks in userspace if this goes in. :-\
>>> Which can let you into putting wrong kind of relations into image.
>> A malicious user can put "wrong" king of relations into the image,
>> regardless of whether the tasks are created in the kernel or in
>> userspace. As long as the creation follows the "instructions" in
>> the image, the result would be the same.
> 
> Wrong as in "fundamentally wrong", not malicious.
> In case of uts_ns, the correct data to put into image is "task uses this uts_ns",
> not "at this point do clone(CLONE_NEWUTS)".

So we are in total agreement: that's how it is done now.

Only task creation per-se, including pid-ns (future work) is done
in userspace. Network namespaces will probably be created in userspace
but attached to tasks in the kernel. Remaining namespaces are covered
in the kernel the way you described.

> 
> BTW, now I'm convinced that nsproxy should not even be mentioned be in an image,
> it's irrelevant technical detail, not future-proof at all.

It's helpful (as is more efficient) to keep it now. We can always
decide to ignore it in the future.

Thanks,

Oren.
