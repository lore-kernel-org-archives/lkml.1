Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZBIT2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZBIT2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZBIT2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:28:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:45486 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZBIT2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=PS/A0bD4OHjt+isAxTNpBQkfFwhb3aniXxM6SUfY5frLclu5v2q4cSg+2me+7ZQHLm
         phSVdgjHJKLTpyLnBTZDZjPxiBnEfFnE3HRZHIsmECtv3lTpeuQDmjsUpgxnyvEktY4g
         lrus8717tX7rQu1v/9StQK1drj3IIYxQe/O1k=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902090940100.8084@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com>
	 <cfd18e0f0902090128i1a4902f4of0d4d830b567602f@mail.gmail.com>
	 <alpine.DEB.1.10.0902090940100.8084@alien.or.mcafeemobile.com>
Date: Tue, 10 Feb 2009 08:28:08 +1300
Message-ID: <cfd18e0f0902091128pf5723c8rcfa1c08d77d4e55d@mail.gmail.com>
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

On Tue, Feb 10, 2009 at 6:42 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Mon, 9 Feb 2009, Michael Kerrisk wrote:
>
>> On Mon, Feb 9, 2009 at 12:23 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
>> > The following patch extends timerfd clockid support to cover the ones
>> > supported by timer_create().
>> > It exports the invalid_clockid() function outside posix-timers.c to allow
>> > timerfd to properly check input parameters.
>> > Andrew, this is (eventually) .30 material, and do not take the patch
>> > until you have Thomas sign off.
>> > Thomas, timerfd uses core hrtimer functions for its tasks. By extending
>> > the clockid support, I assume that the clockids other than CLOCK_MONOTONIC
>> > and CLOCK_REALTIME, behaves the same from a hrtimer caller POV. Right?
>>
>> Hi Davide,
>>
>> Have you done any testing of this patch?  My attempts at testing with
>> clocks other than REALTIME and MONOTONIC all don't work so far.  In
>> some cases, my test programs causes the system to hang.  Try
>> experimenting with the (not yet well tested) test program below, to
>> check the behavior with other clocks.
>
> Michael, no I did not test it

Yep -- I realised afterwards that you had already said that...

> and I did not have even the time to peek
> into the core timer code to see if the usage of other timer types in
> eventfd would create problems. That's why I asked Thomas if they'd behave
> differently from an hrtimer caller POV.
> I'll try to take a look by myself today or tomorrow.

Okay -- hopefully my test program may be useful (even if it is not
itself fully tested yet, it's patterned after a similar test program I
wrote fot the POSIX timers API, so it should mostly work).

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
