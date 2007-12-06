Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbXLFUkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbXLFUkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXLFUkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:40:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:24206 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbXLFUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:40:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nGVe+iwxfn2Y5i960INEUUOgD/TWtUwa7Tu92Kffm9e327o++h0gW82/cyD2hvQMig2llMG+Ah3xqoc7Orfipiss/iUD1f6YSiYmEVppG0gxobq6NlJllXhQ2a1hPviPydDrf9STNZ8W3DUt9Ho70DBlsP3gdw20oYHeMgn90qs=
Message-ID: <3efb10970712061240l3371bd9bj1050f69e5dacf316@mail.gmail.com>
Date: Thu, 6 Dec 2007 21:40:31 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1196971945.1568.107.camel@jnielson-xp.ddns.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
	 <3efb10970712061201l343ad865mae920c3e6d43bfd9@mail.gmail.com>
	 <1196971945.1568.107.camel@jnielson-xp.ddns.mvista.com>
X-Google-Sender-Auth: 43ec1bc372cfdfd7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

> I looked at the console_sem , but i was going to leave that as last..
>
> The problem with the console_sem is that it can get locked from
> interrupt context, which is discouraged with mutex types.. I think it
> will be complicated to convert..

At first it looked simple, but after I sent my mail, I saw also the
interrupt issue...
But nevertheless, I am going to look at it anyway... (I think not today)

Further, I looked also at include/linux/device.h where in the 'struct
device', a semaphore is listed that is used at several places as
mutex. I was wondering what was wise here:
* replacing the semaphore with a mutex at once, and replace it
everywhere in the kernel also, or
* just add a new mutex to the struct, and change the the semaphore to
a mutex per driver, and eventually remove the semaphore from the
struct.

The first option creates the biggest patch, the 2nd leaves the risk
for never removing the semaphore from the struct device...

What is your opinion?


BTW: I also will look at the dvb_frontend.c semaphore->mutex.
I also want to look at the mutex in the PS3 code, but I cannot test it
before I receive my new PS3 ;-)

Remy
