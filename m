Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZLVVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZLVVP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZLVVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:15:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:33033 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZLVVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:15:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=vmmzPLjTKZcVt6WMye5LrAc9wpBlRZkhi4JUvtYvuOMYOIxyoMNwlQ+x2z48Bmsak
	BxxA6YfTW4SjQ53oo5kxw==
MIME-Version: 1.0
In-Reply-To: <20091221085713.GA1622@ucw.cz>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <20091221085713.GA1622@ucw.cz>
Date: Tue, 22 Dec 2009 13:15:21 -0800
Message-ID: <4352991a0912221315y5ba409cbh26baa5937cdf2f76@mail.gmail.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the 
	Linux Kernel
From: Salman Qazi <sqazi@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 12:57 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> Google is implementing power capping, a technology that improves the
>> power efficiency of data centers. There are also some interesting
>> applications of this technology for laptops and cell phones.  Google
>> aims to send most of its Linux technology upstream. So, how can we get
>> this feature into the mainline kernel?
> ...
>> Aside from this, every cgroup has a new quantity added to the CPU
>> component called "Power Capping Priority".  This quantity indicates
>> the order in which the scheduler attributes the time spent injecting
>> idle cycles to specific processes.  This allows us to discriminate
>> among processes when it comes to accounting for the injected idle
>> time.  There is also an indication of interactivity versus batch for
>> the cgroup provided in the CPU component of the cgroup.
>>
>> Basic Algorithm:
>>
>> Rather than blindly blasting the machine with the minimum required
>> idle cycles, our implementation keeps track of naturally occurring
>> idle cycles as follows:
>
> (Rather complex algorithm snipped)
>
> Well.. having all this complexity just for forcing idle... And it
> still will not work, right? Linux kernel is not real time, so you
> can't guarantee anything.

The purpose of all the "complexity" is to avoid injecting idle cycles
when the machine is already sufficiently idle.  That is, to lower the
impact when the feature is not needed.  And you are right, there are
no hard guarantees.  A lot of the practical use will rest on empirical
data.

>
> OTOH realtime people already have tools you could make good use of:
> your power capping approach looks like 'high priority idle task that
> needs to run for 2 seconds every 5 seconds' or something...
>
> Talk to rt people?

At the core of it, you are correct.  However, in our implementation it
also avoids running when the system is already idle and operates at
much finer granularities than seconds.

Which specific tools are you referring to?  Real-time Linux as a whole
is a trade off:  one gets predictable latency in exchange for some
performance.  Any specific contacts that I should direct my inquiries
to?

>                                                                Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
