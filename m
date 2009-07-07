Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZGGP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZGGP7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZGGP7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:59:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52954 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZGGP7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ms3ep6BHg/biY5OjV7f/wA+FsnRow0oFgFELMIOzos0r11ivekD9jme+NmY5IQ+t4n
         aH1wYBOgK4MA+oBx+VEjmLT97l7ogG8VPUT6CnTI6SM9VkHKmsNR9LApbPb1GSJjZ0gr
         3zczbkfHnSFRXa2nH/BYFwTW9LB+lNw6Jk5gY=
MIME-Version: 1.0
In-Reply-To: <1246982101.9777.15.camel@twins>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> 
	<1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com> 
	<1246981444.9777.11.camel@twins> <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com> 
	<1246982101.9777.15.camel@twins>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:59:18 +0100
Message-ID: <a5d9929e0907070859o760fcb16ic88acd0efa3438f3@mail.gmail.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 4:55 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-07-07 at 16:50 +0100, Joao Correia wrote:
>
>> >> Yes. Anything 2.6.31 forward triggers this immediatly during init
>> >> process, at random places.
>> >
>> > Not on my machines it doesn't.. so I suspect its something weird in
>> > your .config or maybe due to some hardware you have that I don't that
>> > triggers different drivers or somesuch.
>>
>> I am not the only one reporting this, and it happens, for example,
>> with a stock .config from a Fedora 11 install.
>>
>> It may, of course, be a funny driver interaction yes, but other than
>> stripping the box piece by piece, how would one go about debugging
>> this otherwise?
>
> One thing to do is stare (or share) at the output
> of /proc/lockdep_chains and see if there's some particularly large
> chains in there, or many of the same name or something.
>
> /proc/lockdep_stats might also be interesting, mine reads like:
>
> [root@opteron ~]# cat /proc/lockdep_stats
>  lock-classes:                          641 [max: 8191]
>  direct dependencies:                  3794 [max: 16384]
>  indirect dependencies:                7557
>  all direct dependencies:             73254
>  dependency chains:                    3716 [max: 32768]
>  dependency chain hlocks:             10167 [max: 163840]
>  in-hardirq chains:                      21
>  in-softirq chains:                     353
>  in-process chains:                    3342
>  stack-trace entries:                 91035 [max: 262144]
>  combined max dependencies:        26035284
>  hardirq-safe locks:                     28
>  hardirq-unsafe locks:                  460
>  softirq-safe locks:                    114
>  softirq-unsafe locks:                  373
>  irq-safe locks:                        123
>  irq-unsafe locks:                      460
>  hardirq-read-safe locks:                 0
>  hardirq-read-unsafe locks:              45
>  softirq-read-safe locks:                 8
>  softirq-read-unsafe locks:              39
>  irq-read-safe locks:                     8
>  irq-read-unsafe locks:                  45
>  uncategorized locks:                   106
>  unused locks:                            1
>  max locking depth:                      14
>  max recursion depth:                    10
>  debug_locks:                             1
>
>
>


I have definitly much higher numbers than those:

[root@hightech git]# cat /proc/lockdep_stats
 lock-classes:                         1793 [max: 8191]
 direct dependencies:                 12032 [max: 16384]
 indirect dependencies:              126642
 all direct dependencies:           1310382
 dependency chains:                   28387 [max: 65536]
 dependency chain hlocks:            100117 [max: 327680]
 in-hardirq chains:                    3029
 in-softirq chains:                    7585
 in-process chains:                   17773
 stack-trace entries:                417613 [max: 1048576]
 combined max dependencies:       523805800
 hardirq-safe locks:                   1074
 hardirq-unsafe locks:                  575
 softirq-safe locks:                   1171
 softirq-unsafe locks:                  445
 irq-safe locks:                       1184
 irq-unsafe locks:                      575
 hardirq-read-safe locks:                 0
 hardirq-read-unsafe locks:              68
 softirq-read-safe locks:                17
 softirq-read-unsafe locks:              55
 irq-read-safe locks:                    17
 irq-read-unsafe locks:                  68
 uncategorized locks:                   103
 unused locks:                            0
 max locking depth:                      16
 max recursion depth:                    11
 debug_locks:                             1
