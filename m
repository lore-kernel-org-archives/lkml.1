Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYJ2CF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYJ2CF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYJ2CFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:05:49 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:46370 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbYJ2CFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:05:49 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Naveen Gupta <ngupta@google.com>
Date: Wed, 29 Oct 2008 13:05:12 +1100
Message-ID: <4907C4D8.2090307@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.17 (X11/20081027)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, s-uchida@ap.jp.nec.com, david@fromorbit.com
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
References: <20081027190131.070061000@elf.corp.google.com>	 <20081027190139.838646000@elf.corp.google.com>	 <20081028002024.GM4985@disturbed>	 <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>	 <20081028214443.GX4985@disturbed>	 <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com>	 <20081028233101.GD17077@disturbed>	 <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com>	 <4907AEE7.5030508@gelato.unsw.edu.au> <2846be6b0810281817x70ea8d4ev378f4893aaf1f61e@mail.gmail.com>
In-Reply-To: <2846be6b0810281817x70ea8d4ev378f4893aaf1f61e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen Gupta wrote:
> 2008/10/28 Aaron Carroll <aaronc@gelato.unsw.edu.au>:
>> Naveen Gupta wrote:
>>> As I said earlier the organization of the AS levels is flat, so we
>>> could use any class (RT, BE, LATENCY) and fold the remaining ones. The
>>> other way which you would probably like is to increase number of
>>> levels and map different classes so that they are not folded.
>> As I said in my reply to the initial posting of this, I think there are
>> only two sensible ways of handling this:
>>
>>  1) Maintain the full number of I/O priorities (1 IDLE, 8 BE, 8 RT);
> 
> But then we are assuming that we are providing different quality of
> service according to classes.

Right.  The ideal solution is a scheduler-independent definition of
RT (Jens?) which you can apply here.  However, it seems to me that you
want to basically ignore RT and IDLE. If you're going to do that, at
least implement sane alternate behaviour.

This solution applies the the principle of least surprise; RT requests
always have higher priority than BE requests, and within the class,
higher level means higher priority.  In your implementation, BE 0 == RT x
and IDLE == BE 7.  This is surprising behaviour.

>>  2) Collapse the levels and only deal with the classes;
> 
> I am not sure if this is meaningful. When all we have is different
> levels of BE, it wouldn't make sense to call them different classes.

It's not meaningful as it stands.  This difference here is that you
at least maintain the ordering of the classes with respect to priority.


           -- Aaron


