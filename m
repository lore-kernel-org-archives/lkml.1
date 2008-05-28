Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYE1BZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYE1BZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYE1BZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:25:18 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:64009 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYE1BZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GIN9EIzEttctbZb/D//Kl9tfnPKYjVD3k4paLoMBcF7l8RdYeKn39oCvCZfjjaLWj2vJruEKSqVmCy1YbBQ60lpgSVwiHn0CLvtN1P1t1gmHew5QBSgQ8u/BBlw2OyhAHUVYNTwhEu9qjKbowyoshl7poxC9CAfulGtYZOJkvOk=
Message-ID: <1f1b08da0805271825j35b3b3a9kbcd894e658aaf439@mail.gmail.com>
Date: Tue, 27 May 2008 18:25:12 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Linus Walleij" <linus.ml.walleij@gmail.com>
Subject: Re: Shifts for clocksources and clockevents
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <63386a3d0805270754w7144799dn1de33774d852d6d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <63386a3d0804090104h59fd6633x41a981eb8a1919ce@mail.gmail.com>
	 <63386a3d0805270754w7144799dn1de33774d852d6d5@mail.gmail.com>
X-Google-Sender-Auth: 4ff5d0ecd43969fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 7:54 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> I asked this on the ARM Linux mailing list a while back, but
> it appears noone there really has a clue. (Or they didn't see
> it.)
>
> Can someone give me a rationale behind the values assigned to
> the .shift field in clock_event_device and clocksource in the current
> ARM platforms?
>
> When I read the documentation in Documentation/hrtimers/highres.txt
> it points me to the PDF
> http://www.linuxsymposium.org/2006/linuxsymposium_procv1.pdf
> from which I get the impression that shift shall be assigned so
> that
>
> (time in ns for 1 cycle)
> --------------------------     = 1
>           shift
>         2
>
> So for a timer running cycles at 1MHz shift would be something like
> 10 so that 1000/1024 ~= 1.
>
> However the current assignments doesn't look like that at all. I get
> the impression that .shift for clock_event_device seem to be set
> to 32 at all times in order to blow 32bit counters up to 64 bit,
> and clocksource .shift is set to something like 18, 20 or 24 for
> unclear reasons.
>
> Any hints here?

The goal is to have the highest shift-value possible (providing
improved slewing accuracy for ntp), while not overflowing on the
multiply if the cycles are not accumulated over an extended period of
time (usually 2-5 seconds).

See the comments in kernel/time/jiffies.c for an example.

thanks
-john
