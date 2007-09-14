Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXINVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXINVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbXINVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:16:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52136 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbXINVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:16:19 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Aidan Thornton <makosoft@googlemail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
       Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <c8b4dbe10709141407p757d0909s5a4d49a7eb44d929@mail.gmail.com>
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <1189791161.2363.8.camel@gaivota>
	 <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>
	 <1189794551.2363.36.camel@gaivota>
	 <37219a840709141220p543b0da9x53f48eabc1cfe8c9@mail.gmail.com>
	 <c8b4dbe10709141407p757d0909s5a4d49a7eb44d929@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 18:16:09 -0300
Message-Id: <1189804569.2363.93.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > There is no reason why the Xceive driver cannot be merged into the
> > current development tree using the hybrid tuner framework as it stands
> > today.
> 
> I'm not convinced this is entirely true. In order to avoid unnecessary
> reinitialisation of the device, the driver needs to know whether the
> device is in analog or digital mode, and I can't see a way of doing it
> with the current API. (I think existing drivers, such as the xc2028
> driver in one branch, use the older analog API and make the digital
> driver a wrapper around it.) Again, I may be missing something.

For sure there are some ways. One dirty way would be to add an static
lock at xc3028 driver. You can rise the lock when firmware is being
uploaded, removing it at the end. This would prevent the troubles you've
mentioned.

A cleaner way would be to create a tasklet for firmware upload. This
will also prevent the driver for a long load time, due to firmware
initialization (a similar change were recently added at ivtv driver).

For sure there are other ways of doing this.
 
Cheers,
Mauro

