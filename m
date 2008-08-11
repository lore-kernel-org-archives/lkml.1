Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYHKS2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYHKS2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHKS2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:28:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYHKS2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:28:05 -0400
Message-ID: <48A08475.1090805@redhat.com>
Date: Mon, 11 Aug 2008 14:27:01 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org
Subject: Re: resume from s2ram regression (bisected to ftrace...)
References: <20080810170801.GA5739@joi> <200808101940.13753.rjw@sisk.pl> <20080810192444.GA5296@joi> <200808102148.03046.rjw@sisk.pl>
In-Reply-To: <200808102148.03046.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 10 of August 2008, Marcin Slusarz wrote:
>   
>> On Sun, Aug 10, 2008 at 07:40:12PM +0200, Rafael J. Wysocki wrote:
>>     
>>> On Sunday, 10 of August 2008, Marcin Slusarz wrote:
>>>       
>>>> Hi
>>>>
>>>> Few days ago I discovered that resume from suspend to ram does not work anymore
>>>> on my 2.6.27-rc2 (actually 796aadeb1b2db9b5d463946766c5bbfd7717158c) gentoo box.
>>>> My computer just boots on resume. Today I had enough time to bisect it and found
>>>> (after 1 panic and 1 build breakage) out "the reason":
>>>>
>>>> $ git bisect good
>>>> d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b is first bad commit
>>>> commit d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b
>>>> Author: Steven Rostedt <rostedt@goodmis.org>
>>>> Date:   Mon May 12 21:20:54 2008 +0200
>>>>
>>>>     ftrace: fix dynamic ftrace selftest
>>>>         
>>> Does it still happen if:
>>> - CONFIG_FTRACE is unset
>>>       
>> no
>>
>>     
>>> - CONFIG_FTRACE is set, but CONFIG_FTRACE_STARTUP_TEST is unset?
>>>       
>> yes
>>     
>
> Thanks for testing.
>
> Well, ftrace is a new feature in 2.6.27, IIRC, so this is not a regression in
> the strict sense.
>
> Still, of couse, there is a bug in ftrace that needs to be fixed.  Steven?
>   
Sorry for the late response.

Red Hat changed its mail servers, and my mail was in limbo for a while.

I'm not doubting that FTRACE enabled breaks suspend to ram, but I find 
it highly unlikely that the commit you posted was the culprit. 
Especially since it still breaks when STARTUP_TEST is disabled. That 
change was a STARTUP_TEST change only.  Perhaps it just moved things 
around enough to cause your issues.

But you say that if you take Linus's latest git tree, and revert only 
this change, it works??

Hmm, this is very strange.

-- Steve


