Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZD1I0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZD1I0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZD1IZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:25:34 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:48096 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbZD1IZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xSeNO+NBtbw07sL7nItf1oMA4kcTf3tYuXSjQUsvoVnA7gA9PPS1S3LdJ68+jSQXNX
         RBqfQgqoZc2TmxFhD0HpT08ChpOXNRemQ4K4LyX5L+0XkQCSiO/H5AzVjumXZdZbZRuz
         XoMKWWz6OUlpJe1oUQhPkrhF2cbwXjQzj+yDc=
MIME-Version: 1.0
In-Reply-To: <1240906292.7620.79.camel@twins>
References: <20090428044426.GA5035@eskimo.com>
	 <20090428143019.EBBF.A69D9226@jp.fujitsu.com>
	 <1240904919.7620.73.camel@twins>
	 <661de9470904280058ub16c66bi6a52d36ca4c2d52c@mail.gmail.com>
	 <1240906292.7620.79.camel@twins>
Date: Tue, 28 Apr 2009 13:55:29 +0530
X-Google-Sender-Auth: 0ba6abae3c60a9f4
Message-ID: <661de9470904280125x8d8b106ke54041724523d221@mail.gmail.com>
Subject: Re: Swappiness vs. mmap() and interactive response
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 1:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-04-28 at 13:28 +0530, Balbir Singh wrote:
>> On Tue, Apr 28, 2009 at 1:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2009-04-28 at 14:35 +0900, KOSAKI Motohiro wrote:
>> >> (cc to linux-mm and Rik)
>> >>
>> >>
>> >> > Hi,
>> >> >
>> >> > So, I just set up Ubuntu Jaunty (using Linux 2.6.28) on a quad core phenom box,
>> >> > and then I did the following (with XFS over LVM):
>> >> >
>> >> > mv /500gig/of/data/on/disk/one /disk/two
>> >> >
>> >> > This quickly caused the system to. grind.. to... a.... complete..... halt.
>> >> > Basically every UI operation, including the mouse in Xorg, started experiencing
>> >> > multiple second lag and delays.  This made the system essentially unusable --
>> >> > for example, just flipping to the window where the "mv" command was running
>> >> > took 10 seconds on more than one occasion.  Basically a "click and get coffee"
>> >> > interface.
>> >>
>> >> I have some question and request.
>> >>
>> >> 1. please post your /proc/meminfo
>> >> 2. Do above copy make tons swap-out? IOW your disk read much faster than write?
>> >> 3. cache limitation of memcgroup solve this problem?
>> >> 4. Which disk have your /bin and /usr/bin?
>> >>
>> >
>> > FWIW I fundamentally object to 3 as being a solution.
>> >
>>
>> memcgroup were not created to solve latency problems, but they do
>> isolate memory and if that helps latency, I don't see why that is a
>> problem. I don't think isolating applications that we think are not
>> important and interfere or consume more resources than desired is a
>> bad solution.
>
> So being able to isolate is a good excuse for poor replacement these
> days?
>

Nope.. I am not saying that. Poor replacement needs to be fixed, but
unfortunately that is very dependent of the nature of the workload,
poor for one might be good for another, of course there is always the
middle ground based on our understanding of desired behaviour. Having
said that, isolating unimportant tasks might be a trade-off that
works, it *does not* replace the good algorithms we need to have a
default, but provides manual control of an otherwise auto piloted
system. With virtualization mixed workloads are becoming more common
on the system.

Providing the swappiness knob for example is needed because sometimes
the user does know what he/she needs.

> Also, exactly because its isolated/limited its sub-optimal.
>
>
>> > I still think the idea of read-ahead driven drop-behind is a good one,
>> > alas last time we brought that up people thought differently.
>>
>> I vaguely remember the patches, but can't recollect the details.
>
> A quick google gave me this:
>
>  http://lkml.org/lkml/2007/7/21/219

Thanks! That was quick
