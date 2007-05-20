Return-Path: <linux-kernel-owner+w=401wt.eu-S1764831AbXETHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764831AbXETHU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759564AbXETHUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:20:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:7840 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530AbXETHUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lbGWFI6E/KJQx0QFm1177DJQ1cnvGuV1Zh5ID2KUL5I0YV5wo/j+fmr6T4Xo/myf9NPql408kAA4Cqt4gOPlRzw+5slgAzWiTfwVQCwXmtJcXQA2do3keM9dF1mdIldarxrBxBppjvaCxlifLAG89tfo/Ud9Z1J7j5OGe3Iuk4I=
Message-ID: <2c0942db0705200020o6dafc9d5k3276c65b3fc9cd4d@mail.gmail.com>
Date: Sun, 20 May 2007 00:20:15 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Gerdau" <mgd@technosis.de>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <200705200859.56327.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com> <200705200812.26391.mgd@technosis.de>
	 <2c0942db0705192330r4004d7bem3556c939c1581553@mail.gmail.com>
	 <200705200859.56327.mgd@technosis.de>
X-Google-Sender-Auth: 6c8a59130dbadeee
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Michael Gerdau <mgd@technosis.de> wrote:
> > > I don't want to say the values aren't useful. I simply think there is
> > > a high noiselevel.
> >
> > The noise is reflected in the standard deviation he has on those rows.
> > The average +- stdev  of one overlaps the average +- stdev of the
> > other,
>
> For the fairness test on cfs13 this simply is wrong.

Ah, you are correct. I was looking at the glxgears test and mostly
ignoring the fairness one as I'm not sure what the test is doing. As
the deviations seem erratic, the fairness test looks like it needs
more passes to converge, but that's just a guess. I honestly don't
know what's going on with that one.

> And for the
> test to be stable would require that avg of one is within avg+-stddev
> of the other (simple overlap does not suffice).

Er, I think you took a different statistics class than I did :-). In
general, the 'true' value we're trying to find/measure has a certain
percentage chance of lying within the average +- n*deviation, with the
percentage going up as n increases, right? (68% for n=1, 95% for n=2,
etc.)

Both distributions have that property, and so to consider one of the
averages as the 'true' value and the other a mere distribution that
has to overlap it is... somewhat inaccurate.

In general, if they both overlap within one standard deviation of each
other, you can say that the data has pretty good agreement with
itself. Which for the glxgears case, it does. The fairness test isn't
so cut and dried, but it's not horrifically out of whack, either. So
I'll reserve judgment on that one :-).
