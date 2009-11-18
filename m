Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZKRAuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZKRAuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZKRAuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:50:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:11866 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZKRAuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JERqQdIBcKQgel5MB1QteU2NZjVlfqzxNGEu53/EWg82YEQmTZ31zsHaNRwTbMRue7
         bjquoKpDZxRmfNWLPKeCRCXEs54cwqE0DzNmfH9GS7LHrtHRRm9mqUxTHtrWe3rMt8gz
         b7gHTSOZyi0XWV9oSgQ+SQyRqdsc1FUUDFN70=
MIME-Version: 1.0
In-Reply-To: <20091116155606.GC29479@sirena.org.uk>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	 <20091107210147.3e754278@hyperion.delvare>
	 <4AF7148C.9090706@thebigcorporation.com>
	 <20091112211255.09cd884a@hyperion.delvare>
	 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	 <20091116155606.GC29479@sirena.org.uk>
Date: Wed, 18 Nov 2009 01:50:05 +0100
Message-ID: <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jean Delvare <khali@linux-fr.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 16, 2009 at 4:56 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Nov 13, 2009 at 11:03:39PM +0100, Thomas Gleixner wrote:
>
>> Q: Why put people yield() into their code ?
>> A: Because:
>>    - it is less nasty than busy waiting for a long time
>>    - it works better
>
> ...
>
>> I can see the idea of using yield() to let other tasks making progress
>> in situations where the hardware is a design failure as well,
>> e.g. bitbang devices. But if we have to deal with hardware which is
>> crap by design yield() is the worst of all answers simply due to its
>> horrible semantics.
>
> What other options are there available for the first case (which is
> often why things work better with the use of yield) that don't involve
> sleeps, or is the idea that in situations like this drivers should
> always sleep?
>
Good point.

I think the yield()s in the device driver code means "I need a small
delay before the hardware is ready" which might translate to some
arbitrary "let me msleep()" or "do not select this task in the next
scheduler run, EVEN IF this task is highest priority".

Can we mark a task sleeping infinitely short, in such a way that the
scheduler does not schedule it at first resched?

During a next timer timeout check, the task would be marked schedulable again.

I assume this is rather dirty and has too much overhead on the timer interfaces.

Regards,

Leon.

-- 
Leon
