Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZAMS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZAMS56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZAMS5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:57:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:37272 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZAMS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uRdtZb0SUaIN4x8rl+z1zFO3bCwOSofiO3ZjikyPlP4+4l5tHGUGmisQR6OOqD6o4b
         0GRrS92xlRKSKwuvqG1owYmW24Nu0q5/XNvoZJrVbq7wBjUhz1WfG7by+g5JWR87zfpX
         JGj8ixzbQPbhAgf/+BgBCsieTAv2hKQMsAVG4=
MIME-Version: 1.0
In-Reply-To: <20090113174522.GA26965@elte.hu>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>
	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu>
Date: Tue, 13 Jan 2009 10:57:46 -0800
Message-ID: <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
From: Tim Hockin <thockin@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 9:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andi Kleen <ak@linux.intel.com> wrote:
>
>> Ingo Molnar wrote:
>>
>>>>> A far more useful design for handling MCE events would be to feed
>>>>> them into printk logging.
>>>> If there's ASCII logging it should be separate from normal printk.
>>>
>>> Well, why?
>>
>> Mostly because the problem is not a kernel issue. Especially large
>> systems with a lot of memory can generate a lot of corrected events (one
>> bit flips in DIMMs are not that uncommon) and it's not good to mix that
>> all up into other kernel messages. It also makes it more clear that it's
>> not a kernel problem, but a hardware problem. I've got feedback over the
>> years that confirm this sight.
>
> Is your argument that syslog is not suitable for the logging of hw events?

I will argue that, yes.

> If that is your argument then the answer is to extend syslog with those
> aspects, instead of widening the quirky /dev based mce ABIs to achieve
> something similar.

I don't like "extend" in this context.  I'd prefer to think of it as a
side-band solution that we need.  And yes, such a solution COULD
obsolete mcelog.  Do you have such a solution done?  Specced?

> If you think that it's suitable then that contradicts your point above.
>
>> [...]
>>
>> None of the points above are real show stoppers for an ASCII interface,
>> but I think with all of this above together considered it's not really
>> an attractive change.
>>
>> I think what could be done is:
>>
>> - Investigate how to make the panic message more information without
>>   adding full decoders.
>>
>> - Implement the default panic timeout method
>>   described above to get automatic on disk logging in common cases.
>>
>> Would that address your concerns?
>
> For me the main blocking point is that mcelog uses a quirky, binary
> side-channel instead of using our main ASCII based logging abstraction
> that we have in Linux: printk + syslog.

It's not particularly quirky - it's a fixed-size ringbuffer.  You're
trying to spin it as some eccentric interface designed by tripped-out
hippies, but it's not really.  It's just a simple piece of plumbing
for a very specific purpose, which exists because there was no better
answer at the time (is there one now?)

> That is a high level argument, while most of your arguments are low level.
> I dont think you can understand my argument if you concentrate on the low
> level only.
>
> We need to resolve this instead of expanding the broken /dev/mcelog
> interface. If we expand the broken interface first then that removes all
> the incentives to enhance the primary logging facility of Linux in this
> area.

I'm 100% on board with that and will even help staff the effort.  This
is something that is VERY HIGHLY desired here.  I already have a
couple peopel looking at this and other HW-error reporting issues.

> Anyway, this merge window has been very crowded in the x86 space already,
> and the MCE topic is not particularly super-important to have right now
> either, so lets skip it for this cycle so that we have more time to
> cleanly work out these details.

Thanks!

> Let me know if there are must-have fixes in it and we can cherry-pick it
> over into x86/urgent.

Tim
