Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbXFUSx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbXFUSx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXFUSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:53:40 -0400
Received: from gw.goop.org ([64.81.55.164]:46919 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbXFUSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:53:39 -0400
Message-ID: <467AC8E9.1000605@goop.org>
Date: Thu, 21 Jun 2007 11:52:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
References: <20070620175737.GA6523@cvg> <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com>
In-Reply-To: <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 20/06/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> This trivial patch adds braces over a one-line
>> loop. That makes code...well... little bit
>> convenient for (possible) further modifications.
>>
> That's generally not done.
>
> It's even in Documentation/CodingStyle :
>
> "
> Do not unnecessarily use braces where a single statement will do.
>
> if (condition)
>        action();
> "

I tend to see "do {} while()" as an exception to this.  I find the 
construct is sufficiently rare that it helps to emphasize it a bit.  For 
example if I'm scanning code and I see:

	while (foo != NULL);

in the corner of my eye, I'm going to think "huh?".  But:

	} while (foo != NULL);

visually "parses" properly, regardless of how near or far the 
corresponding "do  {" is.

(And of course, its consistent with the super extra special while-while 
loop:

	while (foo != NULL) {
		foo = bar();
		piffle();
	} while (foo != NULL);	// make sure we loop properly

;)

    J
