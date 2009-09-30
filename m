Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZI3RhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZI3RhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZI3RhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:37:11 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:62522 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZI3RhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:37:10 -0400
Message-ID: <4AC396CA.6070302@nortel.com>
Date: Wed, 30 Sep 2009 11:35:06 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Henrik Austad <henrik@austad.us>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir>	 <1253623867.20345.156.camel@Palantir> <1253644603.18939.25.camel@laptop>	 <200909270855.49367.henrik@austad.us> <1254240635.7775.44.camel@Palantir>	 <4AC24525.9060607@nortel.com> <1254326306.11233.147.camel@Palantir>
In-Reply-To: <1254326306.11233.147.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2009 17:37:04.0827 (UTC) FILETIME=[A027D0B0:01CA41F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 09:58 AM, Raistlin wrote:
> On Tue, 2009-09-29 at 11:34 -0600, Chris Friesen wrote:

>> a) The child should get an identical bandwidth guarantee as the parent
>> and if that can't be guaranteed then the fork() should fail, maybe with
>> an errno of EBUSY.
>>
> Again, this could be done, pretty easily actually. :-)
> 
>> b) The child should start out with no guarantees (SCHED_OTHER nice 0
>> maybe?) and should have to request a bandwidth guarantee.  This could
>> complicate things in some circumstances because if it can't get the
>> guarantee then it needs to inform the parent somehow.
>>
> Ok, I see and agree, again, to many extents.

> Maybe, since I'm adding (in the next patch I'm going to send
> soon) a flag field in the sched_param_ex structure, we can also use some
> of the bits for deciding how the fork will behave... The main problem
> would be the code will get more complicated, and we thus would have to
> decide if it is worth...

For now it might be best to keep it simple...it can always be extended
later on.  Personally I prefer option "a" above as it makes applications
easier to code.

The only problem that I see is that it will refuse to fork() a task that
has a bandwidth of more than 50% of the system.  I wouldn't expect this
to be a common occurrence, but I could be wrong.

Chris
