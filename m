Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297Ab0A1VZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0A1VZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898Ab0A1VZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:25:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:61405 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0A1VZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:25:24 -0500
Message-ID: <4B61F231.4030108@windriver.com>
Date: Thu, 28 Jan 2010 14:23:13 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to usehw_breakpointAPI
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere> <4B61CD14.7000901@windriver.com> <4B61EC62.6030103@windriver.com> <20100128201745.GE18683@nowhere>
In-Reply-To: <20100128201745.GE18683@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 20:23:13.0579 (UTC) FILETIME=[B790A7B0:01CAA057]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Jan 28, 2010 at 01:58:26PM -0600, Jason Wessel wrote:
>   
>> New version which loses the call back registration, because if we
>> register as a different breakpoint type, perf won't reject it.
>>     
>
>
>
> I don't understand what you mean here.
>
>
>
>   

This was the change:

-       attr.bp_type = HW_BREAKPOINT_X;
+       attr.bp_type = HW_BREAKPOINT_W;

The perf API had extra constraint checks when you did not have a call
back function and the type was HW_BREAKPOINT_X.   Using the
HW_BREAKPOINT_W type avoids the extra checks that would not allow me to
register without providing a call back.  

This issue will go away entirely if we allow the allocation of an event
that is disabled for the purpose of the kernel debugger.  No matter how
you look at it, it is still a work around at the current time.
>>  I didn't
>> see that loop hole in the API the first time around.
>>
>> Also the dr7 fixup in hw_breakpoint.c is not needed.
>>
>> The trickery for entering twice into the __kgdb_notify is gone too.
>>
>> All the regression tests are still passing.
>>     
>
>
>
> Ok. Well, let's go for it, as it's a regression that
> needs to be fixed anyway.
>
> But we'll need to sanitize various things after that :)
>   


Agreed. 

Can I take that to mean you have acked this version of the patch?

Thanks,
Jason.
