Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXCTPQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXCTPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933736AbXCTPQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:16:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:2306 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695AbXCTPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cB4iL3c6GUWcI2XGF4FhmAKqDg9z3VDCnLNaA4ZSwxFUcqEHUxjBl9R73UjH/TzW0TkbKWYMC+8Qu/ouGrPUX667QCyI/Z1i622qVvZdWKySmQiOY+c4ksFga+meT9SdVEEvK9QmLIhw4DXwi0CYj0r+hwmLHrErAsb1dsGH910=
Message-ID: <2c0942db0703200816r36544407o1f60270c5d1da7af@mail.gmail.com>
Date: Tue, 20 Mar 2007 08:16:54 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: RSDL v0.31
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Xavier Bestel" <xavier.bestel@free.fr>, "Al Boldi" <a1426z@gawab.com>,
       "Mike Galbraith" <efault@gmx.de>, "Con Kolivas" <kernel@kolivas.org>,
       ck@vds.kolivas.org, "Serge Belyshev" <belyshev@depni.sinp.msu.ru>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Nicholas Miell" <nmiell@comcast.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <45FFDFF8.2090208@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04>
	 <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <45FFDFF8.2090208@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Mark Lord <lkml@rtr.ca> wrote:
> I've droppped it from my machine -- interactive response is much
> more important for my primary machine right now.

Help out with a data point? Are you running KDE as well? If you are,
then it looks like the common denominator that RSDL is handling poorly
is client-server communication. (KDE's KIO slaves in this case, but X
in general.)

If so, one would hope that a variation on Linus's 2.5.63 pipe wakeup
pass-the-interactivity idea could work here. The problem with that
original patch, IIRC, was that a couple of tasks could bounce their
interactivity bonus back and forth and thereby starve others. Which
might be expected given there was no 'decaying' of the interactivity
bonus, which means you can make a feedback loop.

Anyway, looks like processes that do A -> B -> A communication chains
are getting penalized under RSDL. In which case, perhaps I can make a
test case that exhibits the problem without having to have the same
graphics card or desktop as you.

Ray
