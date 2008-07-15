Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYGOAv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYGOAv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbYGOAvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:51:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:55612 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413AbYGOAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:51:01 -0400
Date: Mon, 14 Jul 2008 17:51:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>
 <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Linus Torvalds wrote:

> On Mon, 14 Jul 2008, david@lang.hm wrote:
>>
>> there was also the issue that was raised about how to handle firmware during
>> suspend/resume. I don't remember seeing a happy solution to that one.
>
> I don't understand why this even keeps coming up.
>
> The only reliable way to handle it is to load the firmware before the
> suspend happens - preferably by simply never unloading it in the first
> place.
>
> Anything else is fraught with problems.
>
> Stuff that expects to eject itself anyway(*) over a suspend event can
> obviously decide to throw it away and require a reload at resume time (by
> virtue of simply re-discovering the whole device!).
>
> Everybody else should just keep the firmware in memory in the driver.
>
> Does it waste some ram? Sure. Tough.

I agree with this, but the proponents of the seperate firmware are listing 
the fact that the firmware doesn't tie up ram as one of the big reasons 
for making the change.

David Lang
