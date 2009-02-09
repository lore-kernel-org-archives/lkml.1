Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZBIXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZBIXCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZBIXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:01:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:8783 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZBIXBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=siWt/iO0Kxhni68SrSPrP4AVj9URJXS+/DjmLzAeG77xekTMTnM2Z1bnbauhHzpBez
         Yab2ygcVubjJ3cv6l9j3iPVbqJVyowLejC2YXLcXorbu52XAgKi+7kkQbbiYI7ouOREh
         llAQNHa4eGZ0lpwFii9sherV6/wAl00aOpyQ4=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902091148520.8503@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com>
	 <cfd18e0f0902090128i1a4902f4of0d4d830b567602f@mail.gmail.com>
	 <alpine.DEB.1.10.0902090940100.8084@alien.or.mcafeemobile.com>
	 <cfd18e0f0902091128pf5723c8rcfa1c08d77d4e55d@mail.gmail.com>
	 <alpine.DEB.1.10.0902091148520.8503@alien.or.mcafeemobile.com>
Date: Tue, 10 Feb 2009 12:01:50 +1300
Message-ID: <cfd18e0f0902091501g5059a12s3dc734d9a936890a@mail.gmail.com>
Subject: Re: [patch 2/2] timerfd extend clockid support
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:10 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Tue, 10 Feb 2009, Michael Kerrisk wrote:
>
>> > and I did not have even the time to peek
>> > into the core timer code to see if the usage of other timer types in
>> > eventfd would create problems. That's why I asked Thomas if they'd behave
>> > differently from an hrtimer caller POV.
>> > I'll try to take a look by myself today or tomorrow.
>>
>> Okay -- hopefully my test program may be useful (even if it is not
>> itself fully tested yet, it's patterned after a similar test program I
>> wrote fot the POSIX timers API, so it should mostly work).
>
> Answer was pretty easy once you look at the code :)
> Timerfd uses core hrtimer functions, and clockids different from the ones
> timerfd already handles, fall into the CPU-timers domain. Domain that is
> not handled by hrtimer.
> Changes to timerfd to support CPU-based timers are really deep (more than
> changes, is a total rewrite). not only to timerfd, but also to CPU-based
> timers to deliver notification by means different than signals.
> Given the amount of code change, and given that a posix-timers->signalfd
> bridge could solve the problem, I'm not going even close to suggest such a
> change.

Okay, thanks for the info.  I've added some text to the
timerfd_create(2) page to explicitly note that the range of clocks
supported by timerfd_create() is smaller than POSIX timers.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
