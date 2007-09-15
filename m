Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXIODJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXIODJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 23:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXIODJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 23:09:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37084 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXIODJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 23:09:19 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
References: <20070913131353.GB26972@linuxtv.org>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
	 <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 00:09:08 -0300
Message-Id: <1189825748.5359.77.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The main discussion in this thread was about drivers in userspace
> are bad because the API will allow binary drivers. 

No. The focus is that userspace API is not needed at all, and the
community believe that this is a regression from all efforts that are
being done by the community to have good quality OSS software.

> The guy
> who works for Hauppauge (again I also have good contacts
> at Hauppauge Europe) writes it's bad - for no technical reason.

Please stop with personal attacks.

> I (again) don't intend to
> release binary drivers. (also keep in mind that ubuntu takes
> everything which makes things work - this matters to the enduser)

Markus, you are thinking that all the community are fool? You used to
state on your website that your intention were to release binary-only
xc5000 drivers. So, please stop with childish and assume what you've
said.

> Mauro is copying the logic of my code and writes I told him I'm ok with
> taking my code without just adding a single line of how his driver
> got developed. (I still wonder why he skipped some significant parts
> of the driver .. because he used the existing one as logic template)
> 
> http://linuxtv.org/hg/~mchehab/tm6000-new/log/14352ab89146/linux/drivers/media/video/tuner-xc2028.c

The basis for tuner-xc2028 driver is tea5767. The xc2028/xc3028 drivers
is very simple:

a) load the proper firmware;
b) send one 32 bits command to select frequency + the frequency divider.

All the rest is the common logic of a tuner driver.

If you take a look at my driver, you will see that the implementation is
different, providing also those functionalities:

- provides a sync during frequency setting, needed by tm6000;
- has the logic to retrieve signal status;
- part of the firmware need to be reload every time you change a freq
(tm6000 driver needs it);
- supports just the firmwares I've identified as being used by tm6000
driver;

The only thing I used is your usbreplay.pl, as properly stated at
README.first (properly pointing to your site).

Again, please stop with personal attacks. This leads to nowhere.

---

>From my side, I've nacked your userspace tuner.

However, I keep open to accept your kernelspace em28xx/xc3028 drivers,
providing that they fits at the current V4L/DVB core.

Changes at common APIs, and especially at Kernel to userspace API should
be discussed with the community. If you accept this fact, you may also
propose improvements at the APIs.

If, after all that were discussed, you're willing to do a serious work,
please send us the patches for em28xx/xc3028 kernelspace drivers.
Otherwise, I'll kindly ask you to take your own way and stop with those
flamewars.
 
Cheers,
Mauro


