Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbXINVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbXINVx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759365AbXINVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:53:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:46561 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269AbXINVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:53:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AIjApYDj6vcJKsyAPrbFM9NQ1xYHcu5xzkpVyzr1BWblThZdVYhkZRb+ta1d2mqvd2Msp2NFFWBX1v8oGEOPyUFmUP6hv8SwU3U3fLHlSty7DlizvrYL8OJA7t2yYdoz+qpV4xVrt2Z1IL5tHEaE1QS68Tvuluv2GMoVZSU9I7U=
Message-ID: <46EB02BC.7000000@gmail.com>
Date: Sat, 15 Sep 2007 01:53:00 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Aidan Thornton <makosoft@googlemail.com>
CC: Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>	 <46E9DDC7.4000403@hauppauge.com>	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>	 <20070914113838.GA29962@linuxtv.org>	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>	 <1189791161.2363.8.camel@gaivota>	 <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>	 <1189794551.2363.36.camel@gaivota>	 <37219a840709141220p543b0da9x53f48eabc1cfe8c9@mail.gmail.com> <c8b4dbe10709141407p757d0909s5a4d49a7eb44d929@mail.gmail.com>
In-Reply-To: <c8b4dbe10709141407p757d0909s5a4d49a7eb44d929@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aidan Thornton wrote:

> 
> I think this will require a rethink of either how the em2880-dvb
> driver works or how frontend drivers work. The current API expects
> users to initialise their frontend and then bind a tuner to it.
> em2880-dvb is a sort of subdriver that attaches to the main driver,
> and doesn't have any control over when or how it initialises its
> tuner, so it can't delay tuner initialisation until the frontend has
> been initialised. (I don't think it's the only hybrid driver that
> works this way either). Of course, I could be missing something.

The em28xx/xc3028 is in fact not too complex. Just for sake of
demonstration, some time back i had posted a dummy driver how it can be
done in a nice and clean way as an example.

The patch assumes some additional standards, you can ignore them. But
you get the general idea from in there.
http://marc.info/?l=linux-video&m=117613833119350&w=2


> 
>> There is no reason why the Xceive driver cannot be merged into the
>> current development tree using the hybrid tuner framework as it stands
>> today.
> 
> I'm not convinced this is entirely true. In order to avoid unnecessary
> reinitialisation of the device, the driver needs to know whether the
> device is in analog or digital mode, and I can't see a way of doing it
> with the current API. (I think existing drivers, such as the xc2028
> driver in one branch, use the older analog API and make the digital
> driver a wrapper around it.) Again, I may be missing something.

You can read this post also for some additional information.
http://marc.info/?l=linux-video&m=117922735929375&w=2

Use the ideas as you deem fit. ;-)

Manu
