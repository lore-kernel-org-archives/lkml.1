Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZIZMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZIZMMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZIZMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:12:18 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:53806 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIZMMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CgRBYV2wMlJ9sgy1yi9oY9mc4aAnEgur3VHVIXbk2KNFAh1kXjEsfUeAYbtIHH4hiZ
         WpCoXqp+c+Ghfb46djZTz1DAla8NivlNmt5RVBFz7aslskbcidcbusPs0/X8EBryP4Hx
         /lGya1Ec9Hq9Vlmt4lY155zHk1zJv0pN9iIrI=
MIME-Version: 1.0
In-Reply-To: <4ABD80C1.8060907@gmail.com>
References: <e25071430909251802o5d269deas9282e07290234a01@mail.gmail.com> 
	<4ABD80C1.8060907@gmail.com>
From: Loren Rogers <loren.rogers@gmail.com>
Date: Sat, 26 Sep 2009 08:12:00 -0400
Message-ID: <e25071430909260512q3d23d3a0h901dc3416a4c2ddd@mail.gmail.com>
Subject: Re: Kernel getting hosed?
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Robert!  I'm pretty sure we have no process mucking with the
clock.  Is there any way I can diagnose "who" is the culprit?  Are
there any useful tools you suggest? We have attempted to use gdb, and
when we get into this "state" we cannot break into gdb.  We have
attempted to use a Lauterbach (j-tag) and when we "break" into this
state, all threads seem to be in the scheduled state like normal.  We
have also attempted to use oprofile, but notice that there are missing
files during the 5 minutes we are in this state.
Thanks,
/Loren


On Fri, Sep 25, 2009 at 10:47 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 09/25/2009 07:02 PM, Loren Rogers wrote:
>>
>> Hello,
>> I am developing a multi-threaded media-based application written for
>> an iMX27-based processor running kernel 2.6.24.  But I'm seeing a
>> weird "phenomenon" where certain processes/threads are not being
>> serviced and my clock (according to gettimeofday()) get's set back as
>> well.  There are many symptoms to this behavior.  Here are some
>> symptoms:
>>
>> 1. It's usually the same application-based threads that are either
>> being serviced or not serviced
>> 2. The problem usually lasts for about 5 and a half minutes and then
>> appears to correct itself
>> 3. I'll see the cpu load for my application-process quickly jump up to
>> 99% right before the phenomenon (according to top)
>> 4. My IP-telnet and serial terminal sessions are both unusable.
>> 5. I have a logging utility with a timestamp feature (gettimeofday())
>> where, once this problem corrects itself, the clock has been set to
>> the exact time the problem started (i.e. let's say the problem starts
>> at 12:00:00, and I'll be logging msgs like 12:01:00, 12:04:22, etc...
>> Then after the problem "stops" the timestamp on my logger is once
>> again 12:00:00).  And when I do a command "date" the clock will say
>> 12:00:00!
>> 6. I think all of my IP-based network threads are being serviced.
>> 7. A colleague wrote a utility on one of the "alive" threads to start
>> collecting proc data once we know we are in this state; and he told me
>> that the proc counters have pretty much halted.
>>
>>
>> My colleagues and I have been chasing this for three weeks now.  I
>> have no clue on how to determine the culprit(s).  At first I thought
>> it was some bad code in the user-based application, but can someone
>> tell me with 100% certainty that this is either a user-space problem
>> or a kernel problem?  If it is a kernel problem, how can a user-space
>> application hose a kernel to this extent?
>>
>> If anybody can help me with some tool or tools to help diagnose the
>> cause of the problem or even where to start looking I would REALLY
>> appreciate it.  Thank you
>
> If the system clock is jumping backwards then unless some process is mucking
> with the clock, sounds like there's some kind of kernel timekeeping problem
> on that platform..
>



-- 
"Some men see things as they are and say why. I dream things that
never were and say why not?" - GBS
