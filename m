Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbZABRex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbZABRex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZABReo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:34:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbZABRen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:34:43 -0500
Date: Fri, 2 Jan 2009 18:34:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Message-ID: <20090102173435.GE6759@elte.hu>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu> <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com> <20090102162120.GG1180@elte.hu> <3f9a31f40901020838v333a968dv937a717e031743eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901020838v333a968dv937a717e031743eb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Fri, Jan 2, 2009 at 9:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > So you want to save kernel size by making less generic kernels tailored to
> 
> My intention is to remove unwanted or useless data from kernel.

which is one of the intentions of CONFIG_EMBEDDED too.

> > a single box [yours in this case] - basically embedding the kernel on 
> > it?
> >
> 
> So you mean choosing x86 is also EMBEDDED ? because it will not gonna 
> run on ARM machine.
> 
> > that is what CONFIG_EMBEDDED=y means in broad terms: "make the kernel 
> > more specific [more embedded] to a particular hw/sw combination".
> 
> Choosing drivers is also Embedded ?

if you bring the argument to its logical extreme then yes. (And human 
history is rich with pointless wars fought over various arguments brought 
to their logical extreme.)

a more pragmatic approach is that EMBEDDED is the specialization stuff 
that can break a box easily without the average kernel tester noticing 
why. Average kernel testers know about drivers and know about the 
architecture they run on. They might not know what apps rely on 
CONFIG_FUTEX for example.

They will probably be aware of the basic CPU type they are using - but the 
whole option brings only marginal benefits (on the order of 10 kilobytes 
of RAM) and the failure scenario is ugly. I have run into it myself: i 
booted a bzImage i assumed would work on a box but it wouldnt due to this. 
It's a subjective category and no amount of talking will bring any 
solution here.

	Ingo
