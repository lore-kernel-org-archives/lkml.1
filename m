Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYLHNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYLHNvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYLHNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:51:08 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:36449 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYLHNvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e+hHCi9s7Z9WcsG/itKQRlmuX4vjRDJsruYooTEN4b4zlJWUZ9V96pbc/58UDELqB3
         47itDoE5d0el7a9MzfgS/mGWn7jY0v9rhRorYpgFJoEmWNR3B5Qk2RWYYaZKCFAiGMAh
         pHZ4ivZHpWfHXoY/oxsJ98W3MJ2kU3er3Ycns=
Message-ID: <c62985530812080551r10759du97e5fc21a1ac4f9e@mail.gmail.com>
Date: Mon, 8 Dec 2008 14:51:05 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-graph-tracer: signal interrupts entry/exit points on outpout
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081208134736.GD29965@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <493C7058.4060709@gmail.com> <1228717172.23742.1.camel@twins>
	 <c62985530812080538p3802f329vf6e12695d734f16d@mail.gmail.com>
	 <20081208134736.GD29965@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/8 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2008/12/8 Peter Zijlstra <a.p.zijlstra@chello.nl>:
>> > On Mon, 2008-12-08 at 01:54 +0100, Frederic Weisbecker wrote:
>> >> Impact: provide interrupt detection on output
>> >>
>> >> Suggested by Ingo.
>> >> If a hardirq is raised, we want it to be signaled on output, so this patch
>> >> adds two arrows on the output to find entry and exit points of a hardirq.
>> >>
>> >> Unfortunately, there are many interrupt entrypoints and these can be differents
>> >> from one arch to another.
>> >>
>> >> The approach here is one of the easiest, but doesn't shine by its scalability:
>> >> we have an array of the interrupt entrypoints names that we compare with the
>> >> symbol of the current traced function, if it matches, we draw the arrow.
>> >>
>> >> Ie:
>> >>
>> >>  1)               |                                unlock_buffer() {
>> >>  1)               |                                  wake_up_bit() {
>> >>  1)               |                                    bit_waitqueue() {
>> >>  1)   0.872 us    |                                      __phys_addr();
>> >>  1)   2.722 us    |                                    }
>> >>  1)               |                                    __wake_up_bit() {
>> >>  1)              ==>                                   __wake_up_bit() {
>> >>  1)               |                                      do_IRQ() {
>> >
>> > Would be much nicer, the current proposal is lost when grepping and adds
>> > a weird visual break in the output.
>>
>>
>> Ok, I will apply it like this in the V2.
>> Thanks!
>
> note that since the IRQ marker always comes on an entry record, there's
> space in the usecs field for something like:
>
>  1)   2.722 us    |                                    }
>  1)               |                                    __wake_up_bit() {
>  1)  [IRQ#123]   ==>                                   __wake_up_bit() {
>
> right?


Heh, I wanted to display the irq number inside the arrow but didn't
think someone would find it useful.
Ok, will apply that too :-)
