Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYFBObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYFBObV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYFBObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:31:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:62742 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYFBObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hxf19WOLUFlzZoJ9/2bt6vkX+JWiJH1kKtZbwBvPDuPLycXkNf9OL5hrN3E/iigKf9cbVg4WOEyrRRY8k/Q4frqFzd8t+ZZXsqMhWBhekHFp0SBtGXbK6iwR+cGhtCaNE8F4ytTay4BW2oT4/2sIrHhzZMH1w5HKqDjow2pxR7o=
Message-ID: <19f34abd0806020731u3d89cfe2m4eef743b377a13ec@mail.gmail.com>
Date: Mon, 2 Jun 2008 16:31:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       "Joe Peterson" <joe@skyrush.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080602122819.GA25136@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48434D57.6030801@skyrush.com> <20080602053256.GF5609@1wt.eu>
	 <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com>
	 <20080602102033.63e4cd18@core>
	 <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
	 <19f34abd0806020339m100fd3f8m6c0c6ff0c08a66d2@mail.gmail.com>
	 <20080602105210.GH18697@devserv.devel.redhat.com>
	 <19f34abd0806020357w6478704dt50226f51c6c62701@mail.gmail.com>
	 <20080602122819.GA25136@devserv.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 2:28 PM, Alan Cox <alan@redhat.com> wrote:
> On Mon, Jun 02, 2008 at 12:57:07PM +0200, Vegard Nossum wrote:
>> I guess this still doesn't explain why TTOU doesn't block (IOW, stop
>> the process, right?) in this case, because my test program does not
>> touch it.
>
> I see the parent process sleeping and the child taking TTOU and going to
> state T. That again is correct.
>
> alan      3219  0.0  0.0   3652   384 pts/5    S    13:11   0:00 ./repro
> alan      3220  0.0  0.0   3652   204 pts/5    T    13:11   0:00 ./repro
>
> If you run it without any straces etc do you see it blocked in T or sitting
> in R ?

Without any straces, it is blocked in T. Like Joe's report.

With strace, it's in R.

Exactly as you said, correct and expected behaviour.

So this is not a kernel problem at all.

I'm sorry for having wasted your time :-(


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
