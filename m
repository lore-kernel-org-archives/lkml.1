Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZLCEP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZLCEP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZLCEP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:15:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65455 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZLCEP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XFYK3T03VlPEI5EaO6NWOzTHPOJUxyZWw5Cb74afxyXpOtX2BkhY0Ng802FRPKKbPb
         PEiaiV+O92FEm9MB6DY1mCzED2nTCk8oNukVslGjsynn6hltI/Cn2G/WpSRJ8hoH/Dzu
         MwciWA+5iyEfSlgkzdHJELIAsNyO8DmBM6FpA=
MIME-Version: 1.0
In-Reply-To: <4B0DDFDA.1030905@redhat.com>
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
	 <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com>
	 <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com>
	 <4B0DDFDA.1030905@redhat.com>
Date: Wed, 2 Dec 2009 23:16:02 -0500
X-Google-Sender-Auth: a541a389bfc4be3f
Message-ID: <c0c067900912022016u32e393cw3fe9e04ba1051253@mail.gmail.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
From: Dan Merillat <dan.merillat@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
       Norbert Preining <preining@logic.at>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Can you try out the patch from
> http://lkml.org/lkml/2009/11/25/467 ?

It's on the system now, I missed your reply for some reason.   Stupid gmail.

So far it's survived the 'open all in tabs' firefox test, which used
to throw it into complete disarray, threw a 1gb file into tmpfs and it
swapped out 150mb and didn't trash.

It's running all the things I normally do in a day all at once, so far
nothing, but it seems to take
a while before things go pear-shaped.

I'll give another update in a day or so.

As an aside, why is swapin so incredibly slow compared to swapout?   I
mean, I understand why (pagefault->swapin *wait* run process new
pagefault->swapin etc) but wouldn't much larger (4mb?) granularity of
swap help with modern high-speed drives?

I've seen a high of 2mb/sec swapin, and 100+mb/sec swapout.

swapoff /dev/swap shows this very clearly - theoretically it should be
"drop enough clean pages to fit everything into RAM, then read the
swap partition in linearly".  It's especially egregious in the case
where a memory-hog has terminated, leaving more free RAM than swapped
pages and swapoff still takes upwards of 10 minutes to complete what
should be a 2-second disk read.
