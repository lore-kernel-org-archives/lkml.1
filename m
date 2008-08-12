Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYHLQjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYHLQjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYHLQjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:39:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:21199 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYHLQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QnwuVyE6cxNlWuhjLwXduyjqsSadRIowgx4mqFdtcy+S8SRA+mvSD0d+QJYKoyVnvo
         uQ5W1l0sTnSsq0LHP4HdV4zNFVyZ+a9G6Dk8LCpJ14gz54J3ZKMG2xhBkwYLqPjWX2ED
         hkU+6dABfhpgvk/w8WywaZ0tN5eWxt8ksLK1s=
Date: Tue, 12 Aug 2008 18:37:28 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org
Subject: Re: resume from s2ram regression (bisected to ftrace...)
Message-ID: <20080812163724.GA5395@joi>
References: <20080810170801.GA5739@joi> <200808101940.13753.rjw@sisk.pl> <20080810192444.GA5296@joi> <200808102148.03046.rjw@sisk.pl> <48A08475.1090805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A08475.1090805@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 02:27:01PM -0400, Steven Rostedt wrote:
> Rafael J. Wysocki wrote:
>> On Sunday, 10 of August 2008, Marcin Slusarz wrote:
>>   
>>> On Sun, Aug 10, 2008 at 07:40:12PM +0200, Rafael J. Wysocki wrote:
>>>     
>>>> On Sunday, 10 of August 2008, Marcin Slusarz wrote:
>>>>       
>>>>> Hi
>>>>>
>>>>> Few days ago I discovered that resume from suspend to ram does not work 
>>>>> anymore
>>>>> on my 2.6.27-rc2 (actually 796aadeb1b2db9b5d463946766c5bbfd7717158c) 
>>>>> gentoo box.
>>>>> My computer just boots on resume. Today I had enough time to bisect it 
>>>>> and found
>>>>> (after 1 panic and 1 build breakage) out "the reason":
>>>>>
>>>>> $ git bisect good
>>>>> d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b is first bad commit
>>>>> commit d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b
>>>>> Author: Steven Rostedt <rostedt@goodmis.org>
>>>>> Date:   Mon May 12 21:20:54 2008 +0200
>>>>>
>>>>>     ftrace: fix dynamic ftrace selftest
>>>>>         
>>>> Does it still happen if:
>>>> - CONFIG_FTRACE is unset
>>>>       
>>> no
>>>
>>>     
>>>> - CONFIG_FTRACE is set, but CONFIG_FTRACE_STARTUP_TEST is unset?
>>>>       
>>> yes
>>>     
>>
>> Thanks for testing.
>>
>> Well, ftrace is a new feature in 2.6.27, IIRC, so this is not a regression 
>> in
>> the strict sense.
>>
>> Still, of couse, there is a bug in ftrace that needs to be fixed.  Steven?
>>   
> Sorry for the late response.
>
> Red Hat changed its mail servers, and my mail was in limbo for a while.
>
> I'm not doubting that FTRACE enabled breaks suspend to ram, but I find it 
> highly unlikely that the commit you posted was the culprit. Especially 
> since it still breaks when STARTUP_TEST is disabled. That change was a 
> STARTUP_TEST change only.  Perhaps it just moved things around enough to 
> cause your issues.
>
> But you say that if you take Linus's latest git tree, and revert only this 
> change, it works??

Yes.

> Hmm, this is very strange.

I agree. Any idea how to debug it?

Marcin
