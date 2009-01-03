Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZACUBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZACUBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZACUBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:01:24 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49185 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbZACUBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:01:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=jftZdZCHuKQl9771/T9ONbE8rnrH7Jb8lg8wJ3+GDs66WEE0JR50930eV6+2AFpBft
         XSxJh/R3NuAxNOIq72QhorYIBlBh4BEDFZz8jkraym3o9GxYA1+ND7LaXptoJkPdVWsm
         F/VOzNT+08gd2q8P+0EUKTHIlbctICTfGUvp8=
Message-ID: <3ae3aa420901031201h3af1f03ct3f9d13db4a793e77@mail.gmail.com>
Date: Sat, 3 Jan 2009 14:01:20 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Chris Adams" <cmadams@hiwaay.net>
Subject: Re: [PATCH] v2 Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Duane Griffin" <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Paul Gortmaker" <p_gortmaker@yahoo.com>,
       "Alessandro Zummo" <a.zummo@towertech.it>, rtc-linux@googlegroups.com
In-Reply-To: <20090103180148.GA1375968@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
	 <20090103022358.GA2454@dastardly.home.dghda.com>
	 <20090103044143.GB1538533@hiwaay.net>
	 <20090103045227.GA5994@dastardly.home.dghda.com>
	 <20090103180148.GA1375968@hiwaay.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Chris Adams <cmadams@hiwaay.net>:

>
> From: Chris Adams <cmadams@hiwaay.net>
>
> The code to handle leap seconds printks an information message when the
> second is inserted or deleted.  It does this while holding xtime_lock.
> However, printk wakes up klogd, and in some cases, the scheduler tries
> to get the current kernel time, trying to get xtime_lock (which results
> in a deadlock).  This moved the printks outside of the lock.  It also
> adds a comment to not use printk while holding xtime_lock.
>
> Signed-off-by: Chris Adams <cmadams@hiwaay.net>

Acked-by: Linas Vepstas <linasvepstas@gmail.com>

BTW, I audited the other code in kernel/time/*.c and it looks like there
are no other printk's under the lock. Not surprising -- if there were,
they'd have been found by now. Indeed, in timekeeping.c line 198,
it seems that someone else had indeed tripped over this :-P

--linas
