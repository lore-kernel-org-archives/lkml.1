Return-Path: <linux-kernel-owner+w=401wt.eu-S1946651AbXD3TmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946651AbXD3TmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946740AbXD3TmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:42:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:2227 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946651AbXD3TmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gsbs7tq2wScum1E2UHyzQciGD/jFbTj0s3AdK7cpjIE0foMTQ/e5rS6FSAInLrUBLvZhDs+hZFwbbVlSIhgZ11UUoNkDr6a7KBLaU8AbiXpMZziyPxkoaIOTZAujT+GeW1p/uHjIXY31h2fkCGL0QMetfPqnBVGFdXuQIMRTviU=
Message-ID: <d9def9db0704301242j33f42b50vf7a7494e32f91038@mail.gmail.com>
Date: Mon, 30 Apr 2007 21:42:04 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       helge.hafting@aitel.hist.no, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.61.0704302029220.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070429182209.267430@gmx.net> <20070429230037.95120@gmx.net>
	 <1177894713.3046.5.camel@pc06.localdom.local>
	 <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no>
	 <20070430115000.194060@gmx.net> <4636058B.3070603@aitel.hist.no>
	 <Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
	 <20070430172547.204810@gmx.net>
	 <Pine.LNX.4.61.0704302029220.29151@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On Apr 30 2007 19:25, Uwe Bugla wrote:
>
> >THIS PATCH IS DONE TO AVOID RAM WASTE FOR CASES IN WHICH IT IS PROVEN THAT
> DST
> >AND DST_CA ARE NOT NEEDED AT ALL!!!!
> >[...]
>
>
> How much on the Theo-meter are we yet?
>

it's enough, I told him that I'll look at it and try to get some other
people involved if it really breaks something it should get stated
out; and I'll refuse any further help if he starts to write any more
abusive mail.

So to his proposal:

the whole noise is about following Makefile patch:
-obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
+obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o
+obj-$(CONFIG_DVB_DST) += dst.o
+obj-$(CONFIG_DVB_DST_CA) += dst_ca.o

that symbol_request is unable to return a valid pointer if DST an
DST_CA aren't selected should be ok because this would only happen if
someone didn't compile them in (an appropriate error message should be
added for that)

I'm trying to look closer at this issue with some other developers, if
it's really that easy to split off the dst module from the bt* objects
without breaking anything, to me the direction this patch goes seems
to be ok, some people stated out that there are problems so I'll try
to get more information about that.

Markus
